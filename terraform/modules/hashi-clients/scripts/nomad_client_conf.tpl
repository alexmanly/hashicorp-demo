
client {
  enabled = true
  servers = ["NOMAD_IDS"]
}

consul {
    # The address to the Consul agent.
    address = "CONSUL_ADDRESS:8500"

    # The service name to register the client with Consul.
    client_service_name = "nomad-client"

    # Enables automatically registering the services.
    auto_advertise = true

    # Enabling the server and client to bootstrap using Consul.
    client_auto_join = true
}

