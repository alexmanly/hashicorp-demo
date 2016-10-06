#!/usr/bin/env bash
set -e

echo "Installing dependencies..."
#sudo apt-get update -y
#sudo apt-get install -y curl unzip

echo "Fetching Vault..."
VAULT_VERSION=0.6.1
cd /tmp
wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -O vault.zip

echo "Installing Vault..."
unzip vault.zip >/dev/null
chmod +x vault
sudo mv vault /usr/local/bin/vault
sudo mkdir -p /opt/vault
rm -f vault.zip

# Read from the file we created
CONSUL_ADDRESS=$(cat /tmp/consul-server-addr | tr -d '\n')

echo "Installing Vault Upstart service..."
sudo mv /tmp/vault_upstart.conf /etc/init/vault.conf
sudo chown root:root /etc/init/vault.conf
sudo chmod 0644 /etc/init/vault.conf

sudo mv /tmp/vault.env /etc/service/vault
sudo chmod 0644 /etc/service/vault
sudo chown root:root /etc/service/vault

sudo mv /tmp/vault_config.json /usr/local/etc/vault_config.json
sudo chown root:root /usr/local/etc/vault_config.json
sudo chmod 0644 /usr/local/etc/vault_config.json
sudo sed -i s/CONSUL_ADDRESS/${CONSUL_ADDRESS}/g /usr/local/etc/vault_config.json

echo "export VAULT_ADDR=http://127.0.0.1:8200" >> ~/.profile
