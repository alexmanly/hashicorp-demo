provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

provider "consul" {
    address = "${var.consul}"
    datacenter = "dc1"
    scheme = "http"
}

# Access a key in Consul
data "consul_keys" "app" {
    key {
        name = "ami"
        path = "service/app/launch_ami"
    }
    key {
        name = "hashiapp_demo_url"
        path = "service/app/hashiapp_demo_url"
    }
    key {
        name = "hashiapp_springboot_demo_url"
        path = "service/app/hashiapp_springboot_demo_url"
    }
}

data "template_file" "install" {
    template = "${file("${path.module}/scripts/install_app.sh.tpl")}"

    vars {
        app_download_url  = "${data.consul_keys.app.var.hashiapp_demo_url}"
        app_springboot_download_url  = "${data.consul_keys.app.var.hashiapp_springboot_demo_url}"
        vault_token       = "${var.vault_token}"
        consul_url        = "${var.consul}"
    }
}

data "template_file" "nomad_server" {
    template = "${file("${path.module}/scripts/nomad_server.hcl.tpl")}"

    vars {
        consul_url = "${var.consul}"
    }
}

data "template_file" "nomad_job" {
    template = "${file("${path.module}/scripts/hashiapp_demo.nomad.tpl")}"

    vars {
        app_download_url  = "${data.consul_keys.app.var.hashiapp_springboot_demo_url}"
        vault_token       = "${var.vault_token}"
        vault_addr        = "${var.consul}"
    }
}

# Start our instance with the dynamic ami value
resource "aws_instance" "app" {
    ami = "${data.consul_keys.app.var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    security_groups = ["${aws_security_group.app.name}"]
    user_data = "${data.template_file.install.rendered}"

    connection {
        user = "${var.user}"
        private_key = "${file(var.key_path)}"
    }

    tags {
        Name = "${var.project}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/rhel_consul.service"
        destination = "/tmp/consul.service"
    }

    provisioner "file" {
        source = "${path.module}/scripts/rhel_nomad.service"
        destination = "/tmp/nomad.service"
    }

    provisioner "file" {
        content = "${data.template_file.nomad_job.rendered}"
        destination = "/tmp/hashiapp-demo.nomad"
    }

    provisioner "file" {
        content = "${data.template_file.nomad_server.rendered}"
        destination = "/tmp/server.hcl"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/install_consul.sh",
            "${path.module}/scripts/install_nomad.sh",
        ]
    }

    provisioner "remote-exec" {
        inline = [
          "sudo sed -i s/PRIVATE_IP/${aws_instance.app.private_ip}/g /opt/nomad/server.hcl",
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/service.sh",
            "${path.module}/scripts/ip_tables.sh",
        ]
    }
}

resource "aws_security_group" "app" {
    name = "${var.project}_sg"
    description = "${var.project} traffic."
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    // These are for internal traffic
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // These are for internal traffic
    ingress {
        from_port = 8090
        to_port = 8090
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // These are for maintenance
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 4646
        to_port = 4648
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

