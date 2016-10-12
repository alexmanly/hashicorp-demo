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
export AMI="<AMI_FROM_PACKER>"
export PASSWORD="<REDACTED>"
export KEY_NAME="<REDACTED>"
export KEY_PATH="<REDACTED>"
export APP_URL="<URL_FROM_APPLICATION>"
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
TF_VAR_access_key=${AAKI} \
TF_VAR_secret_key=${ASAK} \
TF_VAR_key_name=${KEY_NAME} \
TF_VAR_key_path=${KEY_PATH} \
TF_VAR_ami=${AMI} \
TF_VAR_app_download_url=${APP_URL} \
TF_VAR_vault_app_password=${PASSWORD} \
terraform $1
echo "Finished: $(date)"
```

If all is working you should see the following output

```bash
Outputs:

configuration =
Consul URL:

  http://ec2-server1.compute-1.amazonaws.com:8500/ui/

Java App URLs:
  http://ec2-client1.compute-1.amazonaws.com:8090/hello
  http://ec2-client2.compute-1.amazonaws.com:8090/hello
  http://ec2-client3.compute-1.amazonaws.com:8090/hello
  http://ec2-client1.compute-1.amazonaws.com:8090/version
  http://ec2-client2.compute-1.amazonaws.com:8090/version
  http://ec2-client3.compute-1.amazonaws.com:8090/version
  http://ec2-client1.compute-1.amazonaws.com:8090/vault
  http://ec2-client2.compute-1.amazonaws.com:8090/vault
  http://ec2-client3.compute-1.amazonaws.com:8090/vault
  http://ec2-client1.compute-1.amazonaws.com:8090/health
  http://ec2-client2.compute-1.amazonaws.com:8090/health
  http://ec2-client3.compute-1.amazonaws.com:8090/health


Server DNS's:

  ec2-server1.compute-1.amazonaws.com
  ec2-server2.compute-1.amazonaws.com
  ec2-server3.compute-1.amazonaws.com

Client DNS's:

  ec2-client1.compute-1.amazonaws.com
  ec2-client2.compute-1.amazonaws.com
  ec2-client3.compute-1.amazonaws.com
```