#!/usr/bin/env bash
set -e

echo "Installing dependencies..."
#sudo yum update -y
sudo yum install -y unzip wget

echo "Fetching Consul..."
CONSUL=0.7.0
cd /tmp
wget https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_amd64.zip -O consul.zip

echo "Installing Consul..."
unzip consul.zip >/dev/null
chmod +x consul
sudo mv consul /usr/local/bin/consul
sudo mkdir -p /opt/consul/data

# Write the flags to a temporary file
cat >/tmp/consul_flags << EOF
CONSUL_FLAGS="-server -bootstrap-expect=1 -join=ip-172-31-52-218.ec2.internal -data-dir=/opt/consul/data -ui -client=0.0.0.0"
EOF

echo "Installing Systemd service..."
sudo mkdir -p /etc/systemd/system/consul.d
sudo echo '{"service": {"name": "web", "tags": ["hashiapp-demo"], "port": 8080, "check": {"script": "curl http://localhost:8080/hashiapp-demo/rest/health >/dev/null 2>&1", "interval": "10s"}}}' | sudo tee /etc/systemd/system/consul.d/web.json > /dev/null
sudo chown root:root /tmp/consul.service
sudo mv /tmp/consul.service /etc/systemd/system/consul.service
sudo chmod 0644 /etc/systemd/system/consul.service
sudo mv /tmp/consul_flags /etc/sysconfig/consul
sudo chown root:root /etc/sysconfig/consul
sudo chmod 0644 /etc/sysconfig/consul
