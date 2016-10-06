#!/usr/bin/env bash
set -e

echo "Installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y unzip wget curl

echo "Fetching Consul..."
CONSUL=0.7.0
cd /tmp
wget https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_amd64.zip -O consul.zip

echo "Installing Consul..."
unzip consul.zip >/dev/null
chmod +x consul
sudo mv consul /usr/local/bin/consul
sudo mkdir -p /opt/consul/data

# Read from the file we created
SERVER_COUNT=$(cat /tmp/consul-server-count | tr -d '\n')
CONSUL_ADDRESS=$(cat /tmp/consul-server-addr | tr -d '\n')

echo "Installing Consul Upstart service..."
sudo mkdir -p /etc/consul.d
sudo mkdir -p /etc/service
sudo chown root:root /tmp/consul_upstart.conf
sudo mv /tmp/consul_upstart.conf /etc/init/consul.conf
sudo chmod 0644 /etc/init/consul.conf

sudo mv /tmp/consul.env /etc/service/consul
sudo chmod 0644 /etc/service/consul
sudo chown root:root /etc/service/consul
sudo sed -i s/CONSUL_ADDRESS/${CONSUL_ADDRESS}/g /etc/service/consul
sudo sed -i s/BOOTSTRAP_SERVER_COUNT/${SERVER_COUNT}/g /etc/service/consul

sudo mv /tmp/consul_config.json /usr/local/etc/consul_config.json
sudo chmod 0644 /usr/local/etc/consul_config.json
sudo chown root:root /usr/local/etc/consul_config.json
