#!/usr/bin/env bash
set -e

echo "Started: $(date)"
echo "Please, enter the Consul address (URL:PORT)"
read CONSUL_ADDR
echo "Please, enter the Vault token"
read TOKEN
echo "Starting Instance from AMI: $(curl http://${CONSUL_ADDR}/v1/kv/service/app/launch_ami?raw)..."
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
TF_VAR_access_key=${AAKI} TF_VAR_secret_key=${ASAK} TF_VAR_consul=${CONSUL_ADDR} TF_VAR_vault_token=${TOKEN} terraform destroy -force
if [ "$#" -ne 1 ]; then
  TF_VAR_access_key=${AAKI} TF_VAR_secret_key=${ASAK} TF_VAR_consul=${CONSUL_ADDR} TF_VAR_vault_token=${TOKEN} terraform apply
fi
echo "Generating Instance Complete"
echo "Finished: $(date)"
