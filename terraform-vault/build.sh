#!/usr/bin/env bash
set -e

echo "Started: $(date)"
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export CONSUL=ec2-52-90-110-123.compute-1.amazonaws.com:8500
TF_VAR_access_key=${AAKI} TF_VAR_secret_key=${ASAK} TF_VAR_consul-url=${CONSUL} terraform destroy -force
if [ "$#" -ne 1 ]; then
  TF_VAR_access_key=${AAKI} TF_VAR_secret_key=${ASAK} TF_VAR_consul-url=${CONSUL} terraform apply
fi

echo "Finished: $(date)"