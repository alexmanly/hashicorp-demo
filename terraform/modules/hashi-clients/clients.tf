resource "aws_security_group" "hashi_demo_client" {
    name = "hashi_demo_client_${var.platform}"
    description = "Client: Consul, Nomad and Vault internal traffic + maintenance."

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

    ingress {
        from_port = "${var.app_port}"
        to_port = "${var.app_port}"
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

data "template_file" "nomad_client_conf" {
    template = "${file("${path.module}/scripts/nomad_client_conf.tpl")}"

    vars {
        nomad_ips = "${join("\",\"", var.server_instance_ips)}"
        consul_ip    = "${element(var.server_instance_ips, 0)}"
    }
}

data "template_file" "java_app_upstart_conf" {
    template = "${file("${path.module}/scripts/java_app_upstart_conf.tpl")}"

    vars {
        app_sb_download_url = "${var.app_sb_download_url}"
        consul_ip           = "${element(var.server_instance_ips, 0)}"
        app_install_path    = "${var.app_install_path}"
        app_port            = "${var.app_port}"
    }
}

data "template_file" "java_app_nomad_job" {
    template = "${file("${path.module}/scripts/java_app_nomad_job.tpl")}"

    vars {
        app_sb_download_url = "${var.app_sb_download_url}"
        app_install_path    = "${var.app_install_path}"
        app_port            = "${var.app_port}"
    }
}

resource "aws_instance" "client" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.server_count}"
    private_ip = "${element(var.client_instance_ips, count.index)}"
    security_groups = ["${aws_security_group.hashi_demo_client.name}"]

    connection {
        user = "${var.user}"
        private_key = "${file("${var.key_path}")}"
    }

    #Instance tags
    tags {
        Name = "${var.tagName}-client-${count.index}"
    }

    provisioner "file" {
        content = "${data.template_file.java_app_upstart_conf.rendered}"
        destination = "/tmp/java_app_upstart.conf"
    }

    provisioner "file" {
        content = "${data.template_file.java_app_nomad_job.rendered}"
        destination = "/tmp/java_app_nomad.job"
    }

    provisioner "file" {
        content = "${data.template_file.nomad_client_conf.rendered}"
        destination = "/tmp/hashiapp-demo.nomad"
    }
}

resource "null_resource" "app_init" {
    depends_on = ["aws_instance.client"]

    triggers {
        client_instance_ids = "${join(",", aws_instance.client.*.id)}"
    }

    count = "${var.server_count}"

    connection {
        host = "${element(aws_instance.client.*.public_ip, count.index)}"
        user = "${var.user}"
        private_key = "${file("${var.key_path}")}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo stop nomad",
            "sudo rm /var/log/nomad.log",
            "sudo stop consul",
            "sudo rm /var/log/consul.log",
            "echo 'Configuring IP tables...'",
            "sudo iptables -I INPUT -s 0/0 -p tcp --dport ${var.app_port} -j ACCEPT",
            "sudo iptables-save | sudo tee /etc/iptables.rules",
            "echo 'Configuring Consul...'",
            "sudo echo 'CONSUL_FLAGS=\"-join=${var.consul_dns} -data-dir=/opt/consul/data -client=0.0.0.0\"' | sudo tee /etc/service/consul > /dev/null",
            "sudo echo '{\"service\": {\"name\": \"javaapp\", \"tags\": [\"hashiapp-springboot-demo\"], \"port\": ${var.app_port}, \"check\": {\"script\": \"curl http://localhost:${var.app_port}/health >/dev/null 2>&1\", \"interval\": \"10s\"}}}' | sudo tee /etc/consul.d/web-java.json > /dev/null",
            "echo 'Starting Consul...'",
            "sudo start consul",
            "sleep 40",
            "echo 'Configuring Nomad...'",
            "sudo sed -i s/CONSUL_ADDRESS/${element(var.server_instance_ips, 0)}/g /usr/local/etc/nomad_config.json",
            "sudo sed -i s/PRIVATE_IP/${element(var.client_instance_ips, count.index)}/g /usr/local/etc/nomad_config.json",
            "sudo echo '${data.template_file.nomad_client_conf.rendered}' | sudo tee -a /usr/local/etc/nomad_config.json > /dev/null",
            "sudo mv /tmp/java_app_nomad.job ${var.app_install_path}/hashiapp-demo.nomad",
            "sudo chown root:root ${var.app_install_path}/hashiapp-demo.nomad",
            "sudo chmod 0644 ${var.app_install_path}/hashiapp-demo.nomad",
            "echo 'Starting Nomad...'",
            "sudo start nomad",
            "echo 'Installing Java App Upstart service...'",
            "sudo mv /tmp/java_app_upstart.conf /etc/init/javaapp.conf",
            "sudo chown root:root /etc/init/javaapp.conf",
            "sudo chmod 0644 /etc/init/javaapp.conf",
            "sudo start javaapp"
        ]    
    }
}
