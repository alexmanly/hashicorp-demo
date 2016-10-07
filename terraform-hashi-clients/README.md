# Deploy HashiCorp Demo Java Apps to AWS, using Consul, Terraform and Vault

This folder contains modules for Terraform that can setup the Java applications for the HashiCorp demo applications. The infrastructure provider that is used is designated.  See the `variables.tf` file in each for more documentation. 

This terraform project will provision a cluster of nodes in AWS with a Consul agent and a Nomad agent installed and configured.  It will goto Consul and get the AMI id to provision the nodes and then the URLs values to download the Java applications from and then install those applications.

## Provision a Demo Applications

To provision the Java applications in AWS use the following commands:

```bash
echo "Started: $(date)"
echo "Please, enter the consul host"
read CONSUL_HOST
export CONSUL_PORT="8500"
echo "Please, enter the vault token"
read VAULT_TOKEN
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
TF_VAR_vault_addr="http://${CONSUL_HOST}:8200/" \
TF_VAR_vault_token="${VAULT_TOKEN}" \
TF_VAR_consul="${CONSUL_HOST}" \
TF_VAR_nomad_1="$(curl -X GET http://${CONSUL_HOST}:${CONSUL_PORT}/v1/catalog/service/nomad | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[0]["Address"]')" \
TF_VAR_nomad_2="$(curl -X GET http://${CONSUL_HOST}:${CONSUL_PORT}/v1/catalog/service/nomad | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[1]["Address"]')" \
TF_VAR_nomad_3="$(curl -X GET http://${CONSUL_HOST}:${CONSUL_PORT}/v1/catalog/service/nomad | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[2]["Address"]')" \
TF_VAR_access_key=${AAKI} \
TF_VAR_secret_key=${ASAK} \
terraform apply
echo "Finished: $(date)"
```