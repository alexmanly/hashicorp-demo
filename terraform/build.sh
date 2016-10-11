#!/usr/bin/env bash
set -e

echo "Started: $(date)"
export AMI="<AMI_FROM_PACKER>"
export PASSWORD="<REDACTED>"
export APP_URL="<URL_FROM_APPLICATION>"
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
TF_VAR_access_key=${AAKI} \
TF_VAR_secret_key=${ASAK} \
TF_VAR_ami=${AMI} \
TF_VAR_app_download_url=${APP_URL} \
TF_VAR_vault_app_password=${PASSWORD} \
terraform $1
echo "Finished: $(date)"