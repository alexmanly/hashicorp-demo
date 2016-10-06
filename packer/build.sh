#!/usr/bin/env bash
set -e

echo "Started: $(date)"
echo "Please, enter the consul host"
read CONSUL_HOST
echo "Generating AMI..."
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export CONSUL_PORT="8500"
export AMI_ID=$(packer build -var aws_access_key=${AAKI} -var aws_secret_key=${ASAK} -machine-readable basebuild.json | awk -F, '$0 ~/artifact,0,id/ {print $6}' | cut -f2 -d:)

echo "Storing AMI ID ${AMI_ID} in Consul..."
curl -X PUT -d ${AMI_ID} http://${CONSUL_HOST}:${CONSUL_PORT}/v1/kv/service/app/launch_ami
echo "Value from Consul $(curl http://${CONSUL_HOST}:${CONSUL_PORT}/v1/kv/service/app/launch_ami?raw)"
echo "Generating AMI Complete"
echo "Finished: $(date)"