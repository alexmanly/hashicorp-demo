# Deploy HashiCorp Demo Java Apps to AWS, using Consul, Terraform and Vault

This project was taken from HashiCorps [example](https://github.com/hashicorp/consul/tree/master/terraform) of deploying Consul to AWS

This folder contains modules for Terraform that can setup Consul, Vault and Nomad and the Java Application. The infrastructure provider that is used is designated by the folder above. See the `variables.tf` file in each for more documentation. 

This terraform project will provision a cluster of nodes in AWS with a Consul agent and a Nomad agent installed and configured. 

## Provision a Demo Applications

To provision the Java applications in AWS use the following commands:

```bash
#!/usr/bin/env bash
set -e

echo "Started: $(date)"
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
TF_VAR_access_key=${AAKI} \
TF_VAR_secret_key=${ASAK} \
terraform $1
echo "Finished: $(date)"
```