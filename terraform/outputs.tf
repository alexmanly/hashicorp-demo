output "configuration" {
	value = <<CONFIGURATION

Consul URL: 
${module.hashi-servers.consul_url}

Java App URLs: 
${module.hashi-clients.app_urls}

Server DNS's: 
${module.hashi-servers.server_addresses}

Client DNS's:
${module.hashi-clients.server_addresses}

CONFIGURATION
}