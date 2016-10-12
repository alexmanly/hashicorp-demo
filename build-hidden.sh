#!/usr/bin/env bash
set -e

echo "Please enter the application vault password:"
read PASSWORD

echo "Started: $(date)"

pushd ${PWD}
cd ./application-springboot
echo "Compiling Application and Generating WAR file and uploading to AWS s3..."
mvn clean install deploy
export AWS_REGION="us-west-2"
export VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[')
export GROUP_ID=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.groupId | grep -v '\[' | sed s@[.]@/@g)
export ARTIFACT_ID=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.artifactId | grep -v '\[')
export PACKAGING=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.packaging | grep -v '\[')
export APP_URL="https://s3-${AWS_REGION}.amazonaws.com/${ARTIFACT_ID}/release/${GROUP_ID}/${ARTIFACT_ID}/${VERSION}/${ARTIFACT_ID}-${VERSION}.${PACKAGING}"
echo "Generating artifact URL Complete...[${APP_URL}]"
popd

pushd ${PWD}
cd ./packer
echo "Generating AMI..."
export AAKI=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export ASAK=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export AMI_ID=$(packer build -var aws_access_key=${AAKI} -var aws_secret_key=${ASAK} -machine-readable basebuild.json | awk -F, '$0 ~/artifact,0,id/ {print $6}' | cut -f2 -d:)
echo "Generating AMI Complete...[${AMI_ID}]"
popd

pushd ${PWD}
cd ./terraform
echo "Generating Cluster..."
export KEY_NAME="amanly-vault"
export KEY_PATH="/Users/alex/.ssh/amanly-vault.pem"
TF_VAR_access_key=${AAKI} \
TF_VAR_secret_key=${ASAK} \
TF_VAR_key_name=${KEY_NAME} \
TF_VAR_key_path=${KEY_PATH} \
TF_VAR_ami=${AMI} \
TF_VAR_app_download_url=${APP_URL} \
TF_VAR_vault_app_password=${PASSWORD} \
terraform apply
echo "Generating Cluster Complete"
popd

echo "Finished: $(date)"