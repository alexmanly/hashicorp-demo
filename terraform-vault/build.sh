#!/usr/bin/env bash
set -e

echo "Started: $(date)"
echo "Please, enter the consul address (URL:PORT)"
read CONSUL_ADDR
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
TF_VAR_access_key=${AAKI} TF_VAR_secret_key=${ASAK} TF_VAR_consul-url=$CONSUL_ADDR terraform destroy -force
if [ "$#" -ne 1 ]; then
  TF_VAR_access_key=${AAKI} TF_VAR_secret_key=${ASAK} TF_VAR_consul-url=$CONSUL_ADDR terraform apply
fi

echo "Finished: $(date)"