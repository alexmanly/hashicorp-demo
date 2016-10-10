output "consul_url" {
    value = "${module.hashi-servers.consul_url}"
}

output "server_addresses" {
    value = "${module.hashi-servers.server_addresses}"
}

output "client_addresses" {
    value = "${module.hashi-clients.client_addresses}"
}
