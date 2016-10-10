#!/usr/bin/env bash
set -e

echo "Started: $(date)"
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
TF_VAR_access_key=${AAKI} \
TF_VAR_secret_key=${ASAK} \
terraform $1
echo "Finished: $(date)"