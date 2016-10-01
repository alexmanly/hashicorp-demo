# Deploy Vault to AWS with a Consul Backend

This project was taken from HashiCorps [example](https://github.com/hashicorp/vault/tree/master/terraform/aws) of deploying Vault to AWS

This folder contains a Terraform module for deploying Vault to AWS
(within a VPC). It can be used as-is or can be modified to work in your
scenario, but should serve as a strong starting point for deploying Vault.

See `variables.tf` for a full reference to the parameters that this module
takes and their descriptions.

## Provision a Vault Server in AWS with a Consul Backend

To provision the Vault Server in AWS use the following commands:

```bash
export AAKI=MY-AWS-ID
export ASAK=MY-AWS-KEY
export CONSUL=MY-CONSUL-ADDR
TF_VAR_access_key=${AAKI} TF_VAR_secret_key=${ASAK} TF_VAR_consul-url=${CONSUL} terraform apply
```