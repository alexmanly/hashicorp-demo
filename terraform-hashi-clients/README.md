# Deploy HashiCorp Demo Java Apps to AWS, using Consul, Terraform and Vault

This folder contains modules for Terraform that can setup the Java applications for the HashiCorp demo applications. The infrastructure provider that is used is designated.  See the `variables.tf` file in each for more documentation. 

This terraform project will provision a cluster of nodes in AWS with a Consul agent and a Nomad agent installed and configured.  It will goto Consul and get the AMI id to provision the nodes and then the URLs values to download the Java applications from and then install those applications.

## Provision a Demo Applications

To provision the Java applications in AWS use the following commands:

```bash
echo "Started: $(date)"
echo "Please, enter the consul host"
read CONSUL_HOST
echo "Please, enter the vault host"
read VAULT_HOST
echo "Please, enter the vault token"
read VAULT_TOKEN
echo "Please, enter the nomad 1 host"
read NOMAD_1
echo "Please, enter the nomad 2 host"
read NOMAD_2
echo "Please, enter the nomad 3 host"
read NOMAD_3
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
TF_VAR_vault_addr="http://${VAULT_HOST}:8200/" \
TF_VAR_vault_token="${VAULT_TOKEN}" \
TF_VAR_consul="${CONSUL_HOST}" \
TF_VAR_nomad_1="${NOMAD_1}" \
TF_VAR_nomad_2="${NOMAD_2}" \
TF_VAR_nomad_3="${NOMAD_3}" \
TF_VAR_access_key=${AAKI} \
TF_VAR_secret_key=${ASAK} \
terraform apply
echo "Finished: $(date)"
```