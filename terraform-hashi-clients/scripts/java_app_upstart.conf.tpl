description "Hashiapp Demo Java Application"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

script
  # Make sure to use all our CPUs, because Nomad can block a scheduler thread
  export VAULT_ADDR=${vault_addr}
  export VAULT_TOKEN=${vault_token}

  exec /usr/bin/java -jar /opt/java_hashidemo/hashiapp-springboot-demo.jar >>/var/log/java_app.log 2>&1
end script