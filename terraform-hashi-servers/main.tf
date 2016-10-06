provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "server" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    security_groups = ["${aws_security_group.hashi_servers.name}"]

    connection {
        user = "${var.user}"
        private_key = "${file("${var.key_path}")}"
    }

    #Instance tags
    tags {
        Name = "${var.tagName}-${count.index}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/${var.consul_service_conf}"
        destination = "/tmp/${var.consul_service_conf}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/${var.consul_agent_conf}"
        destination = "/tmp/${var.consul_agent_conf}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/${var.consul_agent_env}"
        destination = "/tmp/${var.consul_agent_env}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/${var.vault_service_conf}"
        destination = "/tmp/${var.vault_service_conf}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/${var.vault_agent_conf}"
        destination = "/tmp/${var.vault_agent_conf}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/${var.vault_agent_env}"
        destination = "/tmp/${var.vault_agent_env}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/${var.nomad_service_conf}"
        destination = "/tmp/${var.nomad_service_conf}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/${var.nomad_agent_conf}"
        destination = "/tmp/${var.nomad_agent_conf}"
    }

    provisioner "file" {
        source = "${path.module}/scripts/${var.nomad_agent_env}"
        destination = "/tmp/${var.nomad_agent_env}"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.servers} > /tmp/consul-server-count",
            "echo ${aws_instance.server.0.private_dns} > /tmp/consul-server-addr",
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/consul_install.sh",
            "${path.module}/scripts/vault_install.sh",
            "${path.module}/scripts/nomad_install.sh",
            "${path.module}/scripts/ip_tables.sh",
            "${path.module}/scripts/service.sh",
        ]
    }
}

resource "aws_security_group" "hashi_servers" {
    name = "hashi_servers_${var.platform}"
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
