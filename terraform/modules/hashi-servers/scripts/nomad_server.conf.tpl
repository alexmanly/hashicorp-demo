
server {
  enabled = true
  bootstrap_expect = ${server_count}
}

consul {
    # The address to the Consul agent.
    address = "${consul_ip}:8500"

    # The service name to register the server with Consul.
    server_service_name = "nomad"

    # Enables automatically registering the services.
    auto_advertise = true

    # Enabling the server and client to bootstrap using Consul.
    server_auto_join = true
}

