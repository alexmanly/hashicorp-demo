# Deploy HashiCorp Demo Java Apps to AWS, using Consul, Terraform and Vault

This folder contains modules for Terraform that can setup the Java applications for the HashiCorp demo applications. The infrastructure provider that is used is designated.  See the `variables.tf` file in each for more documentation. 

This terraform project will provision a cluster of nodes in AWS with a Consul agent and a Nomad agent installed and configured.  It will goto Consul and get the AMI id to provision the nodes and then the URLs values to download the Java applications from and then install those applications.

## Provision a Demo Applications

To provision the Java applications in AWS use the following commands:

```bash
export AAKI=MY-AWS-ID
export ASAK=MY-AWS-KEY
export CONSUL=MY-CONSUL-ADDR
export TOKEN=MY-VAULT-TOKEN
echo "Starting Instance from AMI: $(curl http://${CONSUL}/v1/kv/service/app/launch_ami?raw)..."
TF_VAR_access_key=${AAKI} TF_VAR_secret_key=${ASAK} TF_VAR_consul=${CONSUL_ADDR} TF_VAR_vault_token=${TOKEN} terraform apply
```