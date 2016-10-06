output "server_address" {
    value = ["${aws_instance.client.*.public_dns}"]
}
