#!/usr/bin/env bash
set -e

echo 'Configuring IP tables...'
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8080 -j ACCEPT
sudo iptables -I INPUT -s 0/0 -p tcp --dport 8090 -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables.rules

echo "Downloading Tomcat web app..."
sudo curl -L "${app_download_url}" > /tmp/hashiapp-demo.war
sudo mv /tmp/hashiapp-demo.war /opt/tomcat_hashidemo/webapps/hashiapp-demo.war

echo "Installing Tomcat Upstart service..."
sudo mv /tmp/tomcat_app_upstart.conf /etc/init/tomcat.conf
sudo chown root:root /etc/init/tomcat.conf
sudo chmod 0644 /etc/init/tomcat.conf
sudo start tomcat

echo "Downloading Java app..."
sudo curl -L "${app_sb_download_url}" > /tmp/hashiapp-springboot-demo.jar

echo "Installing Java App Upstart service..."
sudo mv /tmp/java_app_upstart.conf /etc/init/javaapp.conf
sudo chown root:root /etc/init/javaapp.conf
sudo chmod 0644 /etc/init/javaapp.conf
sudo start javaapp

echo 'Configuring Consul...'
sudo sed -i s/CONSUL_ADDRESS/${consul}/g /etc/service/consul
sudo echo '{"service": {"name": "web1", "tags": ["hashiapp-demo"], "port": 8080, "check": {"script": "curl http://localhost:8080/hashiapp-demo/rest/health >/dev/null 2>&1", "interval": "10s"}}}' | sudo tee /etc/consul.d/web1.json > /dev/null
sudo echo '{"service": {"name": "web2", "tags": ["hashiapp-springboot-demo"], "port": 8090, "check": {"script": "curl http://localhost:8090/health >/dev/null 2>&1", "interval": "10s"}}}' | sudo tee /etc/consul.d/web2.json > /dev/null

echo 'Starting Consul...'
sudo start consul
sleep 15

echo 'Configuring Nomad...'
sudo sed -i s/PRIVATE_IP/$(curl http://169.254.169.254/latest/meta-data/local-ipv4)/g /usr/local/etc/nomad_config.json
sudo sed -i s/CONSUL_ADDRESS/${consul}/g /usr/local/etc/nomad_config.json
sudo sed -i s/NOMAD_1/${nomad_1}/g /usr/local/etc/nomad_config.json
sudo sed -i s/NOMAD_2/${nomad_2}/g /usr/local/etc/nomad_config.json
sudo sed -i s/NOMAD_3/${nomad_3}/g /usr/local/etc/nomad_config.json

echo 'Starting Nomad...'
sudo start nomad
