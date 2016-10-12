
server {
  enabled = true
  bootstrap_expect = SERVER_COUNT
}

consul {
    # The address to the Consul agent.
    address = "CONSUL_ADDRESS:8500"

    # The service name to register the server with Consul.
    server_service_name = "nomad"

    # Enables automatically registering the services.
    auto_advertise = true

    # Enabling the server and client to bootstrap using Consul.
    server_auto_join = true
}

