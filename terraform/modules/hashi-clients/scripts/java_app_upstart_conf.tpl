description "Hashiapp Demo Java Application"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

script
if [ ! -f ${app_install_path}/hashiapp-springboot-demo.jar ]; then
	echo "Downloading Java app..."
  sudo mkdir -p ${app_install_path}
  sudo curl -L "${app_download_url}" > /tmp/hashiapp-springboot-demo.jar
  sudo mv /tmp/hashiapp-springboot-demo.jar ${app_install_path}/hashiapp-springboot-demo.jar
  sudo chown root:root ${app_install_path}/hashiapp-springboot-demo.jar
  sudo chmod 0644 ${app_install_path}/hashiapp-springboot-demo.jar
  cat << EOF | sudo tee ${app_install_path}/application.properties
server.compression.enabled: true
server.compression.min-response-size: 1
application.version: 1.0.0
server.port = ${app_port}
EOF
  sudo chown root:root ${app_install_path}/application.properties
  sudo chmod 0644 ${app_install_path}/application.properties
  export VAULT_TOKEN=$(curl -sf "http://${consul_ip}:8500/v1/kv/service/vault/root-token?raw")
  cat << EOF | sudo tee ${app_install_path}/bootstrap.properties
spring.application.name: ${vault_app_name}
spring.cloud.vault.host: ${consul_ip}
spring.cloud.vault.port: 8200
spring.cloud.vault.scheme: http
spring.cloud.vault.token: $${VAULT_TOKEN}
spring.cloud.vault.connection-timeout: 5000
spring.cloud.vault.read-timeout: 15000
spring.cloud.vault.config.order: -10
EOF
  sudo chown root:root ${app_install_path}/bootstrap.properties
  sudo chmod 0644 ${app_install_path}/bootstrap.properties
fi

  exec /usr/bin/java -jar ${app_install_path}/hashiapp-springboot-demo.jar --spring.config.location=${app_install_path}/ >>/var/log/java_app.log 2>&1
end script