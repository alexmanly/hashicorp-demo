output "server_addresses" {
    value = "${join("\n  ", formatlist("%s", aws_instance.server.*.public_dns))}"
}

output "consul_dns" {
    value = "${element(aws_instance.server.*.public_dns, 0)}"
}

output "consul_url" {
    value = "http://${element(aws_instance.server.*.public_dns, 0)}:8500/ui/"
}
