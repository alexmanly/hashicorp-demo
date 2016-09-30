# Name the region, if omitted, the default "global" region will be used.
region = "europe"

# Persist data to a location that will survive a machine reboot.
data_dir = "/opt/nomad/"

# Bind to all addresses so that the Nomad agent is available both on loopback
# and externally.
bind_addr = "0.0.0.0"

# Advertise an accessible IP address so the server is reachable by other servers
# and clients. The IPs can be materialized by Terraform or be replaced by an
# init script.
advertise {
    http = "IP_ADDRESS:4646"
    rpc = "IP_ADDRESS:4647"
    serf = "IP_ADDRESS:4648"
}

# Ship metrics to monitor the health of the cluster and to see task resource
# usage.
#telemetry {
#    statsite_address = "52.90.110.123:8125"
#    disable_hostname = true
#}

# Enable debug endpoints.
enable_debug = true

server {
    enabled = true
    bootstrap_expect = 1
}

consul {
    # The address to the Consul agent.
    address = "CONSUL_URL"

    # The service name to register the server and client with Consul.
    server_service_name = "nomad"

    # Enables automatically registering the services.
    auto_advertise = true

    # Enabling the server and client to bootstrap using Consul.
    server_auto_join = true
}