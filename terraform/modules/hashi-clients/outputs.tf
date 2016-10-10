output "client_addresses" {
    value = "${join("\n  ", formatlist("http://%s:8090/hello", aws_instance.client.*.public_dns))}"
}
