provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

provider "consul" {
    address = "${var.consul}:8500"
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

data "template_file" "configure" {
    template = "${file("${path.module}/scripts/configure.sh.tpl")}"

    vars {
        consul              = "${var.consul}"
        nomad_1             = "${var.nomad_1}"
        nomad_2             = "${var.nomad_2}"
        nomad_3             = "${var.nomad_3}"
        app_download_url    = "${data.consul_keys.app.var.hashiapp_demo_url}"
        app_sb_download_url = "${data.consul_keys.app.var.hashiapp_springboot_demo_url}"
    }
}

data "template_file" "java_app" {
    template = "${file("${path.module}/scripts/java_app_upstart.conf.tpl")}"

    vars {
        vault_addr          = "${var.vault_addr}"
        vault_token         = "${var.vault_token}"
    }
}

data "template_file" "tomcat_app" {
    template = "${file("${path.module}/scripts/tomcat_app_upstart.conf.tpl")}"

    vars {
        vault_addr          = "${var.vault_addr}"
        vault_token         = "${var.vault_token}"
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

resource "aws_instance" "client" {
    ami = "${data.consul_keys.app.var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    security_groups = ["${aws_security_group.hashi_clients.name}"]

    connection {
        user = "${var.user}"
        private_key = "${file("${var.key_path}")}"
    }

    #Instance tags
    tags {
        Name = "${var.tagName}-${count.index}"
    }

    provisioner "file" {
        content = "${data.template_file.configure.rendered}"
        destination = "/tmp/configure.sh"
    }

    provisioner "file" {
        content = "${data.template_file.java_app.rendered}"
        destination = "/tmp/java_app_upstart.conf"
    }

    provisioner "file" {
        content = "${data.template_file.tomcat_app.rendered}"
        destination = "/tmp/tomcat_app_upstart.conf"
    }

    provisioner "file" {
        content = "${data.template_file.nomad_job.rendered}"
        destination = "/tmp/hashiapp-demo.nomad"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/configure.sh",
          "/tmp/configure.sh",
          "rm /tmp/configure.sh",
        ]
    }
}

resource "aws_security_group" "hashi_clients" {
    name = "hashi_clients_${var.platform}"
    description = "Consul, Nomad and Vault internal traffic + maintenance."

    // These are for internal traffic
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

    ingress {
        from_port = 8200
        to_port = 8200
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8300
        to_port = 8302
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8400
        to_port = 8400
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 4646
        to_port = 4648
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8500
        to_port = 8500
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

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
