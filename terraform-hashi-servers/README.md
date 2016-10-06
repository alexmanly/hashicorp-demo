# Deploy a Consul, Vault and Nomad Server Cluster to AWS

This project was taken from HashiCorps [example](https://github.com/hashicorp/consul/tree/master/terraform) of deploying Consul to AWS

This folder contains modules for Terraform that can setup Consul, Vault and Nomad for various systems. The infrastructure provider that is used is designated by the folder above. See the `variables.tf` file in each for more documentation. 

## Provision a HashiCorp Cluster to AWS

To provision the Consul cluster in AWS use the following commands:

```bash
export AAKI=MY-AWS-ID
export ASAK=MY-AWS-KEY
TF_VAR_access_key=${AAKI} TF_VAR_secret_key=${ASAK} terraform apply
```