output "app_urls" {
    value = <<CONFIGURATION
  ${join("\n  ", formatlist("http://%s:8090/hello", aws_instance.client.*.public_dns))}
  ${join("\n  ", formatlist("http://%s:8090/version", aws_instance.client.*.public_dns))}
  ${join("\n  ", formatlist("http://%s:8090/vault", aws_instance.client.*.public_dns))}
  ${join("\n  ", formatlist("http://%s:8090/health", aws_instance.client.*.public_dns))}
CONFIGURATION
}

output "server_addresses" {
    value = "\n  ${join("\n  ", formatlist("%s", aws_instance.client.*.public_dns))}"
}
