#!/usr/bin/env bash
set -e

echo "Installing dependencies..."
#sudo apt-get update -y
#sudo apt-get install -y unzip curl

echo "Fetching Nomad..."
NOMAD_VERSION=0.4.1
cd /tmp
wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -O nomad.zip

echo "Installing Nomad..."
unzip nomad.zip >/dev/null
chmod +x nomad
sudo mv nomad /usr/local/bin/nomad
sudo mkdir -p /opt/nomad
rm -f nomad.zip

# Read from the file we created
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
SERVER_COUNT=$(cat /tmp/consul-server-count | tr -d '\n')
CONSUL_ADDRESS=$(cat /tmp/consul-server-addr | tr -d '\n')

echo "Installing Nomad Upstart service..."
sudo mv /tmp/nomad_upstart.conf /etc/init/nomad.conf
sudo chown root:root /etc/init/nomad.conf
sudo chmod 0644 /etc/init/nomad.conf

sudo mv /tmp/nomad.env /etc/service/nomad
sudo chmod 0644 /etc/service/nomad
sudo chown root:root /etc/service/nomad

sudo mv /tmp/nomad_config.json /usr/local/etc/nomad_config.json
sudo chown root:root /usr/local/etc/nomad_config.json
sudo chmod 0644 /usr/local/etc/nomad_config.json
sudo sed -i s/PRIVATE_IP/${PRIVATE_IP}/g /usr/local/etc/nomad_config.json
sudo sed -i s/CONSUL_ADDRESS/${CONSUL_ADDRESS}/g /usr/local/etc/nomad_config.json
sudo sed -i s/BOOTSTRAP_SERVER_COUNT/${SERVER_COUNT}/g /usr/local/etc/nomad_config.json


