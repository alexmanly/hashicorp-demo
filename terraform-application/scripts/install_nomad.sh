#!/usr/bin/env bash
set -e

echo "Installing dependencies..."
#sudo yum update -y
sudo yum install -y unzip wget

echo "Fetching Nomad..."
NOMAD=0.4.1
cd /tmp
wget https://releases.hashicorp.com/nomad/${NOMAD}/nomad_${NOMAD}_linux_amd64.zip -O nomad.zip

echo "Installing Nomad..."
unzip nomad.zip >/dev/null
chmod +x nomad
sudo mv nomad /usr/local/bin/nomad
sudo mkdir -p /opt/nomad

echo "Installing Systemd service..."
sudo mv /tmp/server.hcl /opt/nomad/server.hcl
sudo chown root:root /opt/nomad/server.hcl
sudo chmod 0644 /opt/nomad/server.hcl
sudo mkdir -p /etc/systemd/system/nomad.d
sudo chown root:root /tmp/nomad.service
sudo mv /tmp/nomad.service /etc/systemd/system/nomad.service
sudo chmod 0644 /etc/systemd/system/nomad.service
sudo touch /etc/sysconfig/nomad
sudo chown root:root /etc/sysconfig/nomad
sudo chmod 0644 /etc/sysconfig/nomad

