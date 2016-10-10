#!/usr/bin/env bash
set -e

echo "Fetching Consul..."
CONSUL=0.7.0
cd /tmp
wget https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_amd64.zip -O consul.zip

echo "Installing Consul..."
unzip consul.zip >/dev/null
chmod +x consul
sudo mv consul /usr/local/bin/consul
sudo mkdir -p /opt/consul/data
rm -f consul.zip

echo "Installing Consul Upstart service..."
sudo mkdir -p /etc/consul.d
sudo mkdir -p /etc/service
sudo chown root:root /tmp/consul_upstart.conf
sudo mv /tmp/consul_upstart.conf /etc/init/consul.conf
sudo chmod 0644 /etc/init/consul.conf

echo "Installing Consul service environment file..."
sudo mv /tmp/consul.env /etc/service/consul
sudo chmod 0644 /etc/service/consul
sudo chown root:root /etc/service/consul

echo "Installing Consul service configuration file..."
sudo mv /tmp/consul_config.json /usr/local/etc/consul_config.json
sudo chmod 0644 /usr/local/etc/consul_config.json
sudo chown root:root /usr/local/etc/consul_config.json
