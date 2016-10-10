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

echo "Installing Nomad Upstart service..."
sudo mv /tmp/nomad_upstart.conf /etc/init/nomad.conf
sudo chown root:root /etc/init/nomad.conf
sudo chmod 0644 /etc/init/nomad.conf

echo "Installing Nomad service environment file..."
sudo mv /tmp/nomad.env /etc/service/nomad
sudo chmod 0644 /etc/service/nomad
sudo chown root:root /etc/service/nomad

echo "Installing Nomad service configuration file..."
sudo mv /tmp/nomad_config.json /usr/local/etc/nomad_config.json
sudo chown root:root /usr/local/etc/nomad_config.json
sudo chmod 0644 /usr/local/etc/nomad_config.json
