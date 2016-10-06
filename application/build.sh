#!/usr/bin/env bash
set -e

echo "Started: $(date)"
echo "Please, enter the consul host"
read CONSUL_HOST

echo "Compiling Application and Generating WAR file and uploading to AWS s3"
mvn clean install deploy

export CONSUL_PORT="8500"
export CONSUL_KEY="service/app/hashiapp_demo_url"
export AWS_REGION="us-west-2"
export VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[')
export GROUP_ID=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.groupId | grep -v '\[' | sed s@[.]@/@g)
export ARTIFACT_ID=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.artifactId | grep -v '\[')
export PACKAGING=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.packaging | grep -v '\[')
export URL="https://s3-${AWS_REGION}.amazonaws.com/${ARTIFACT_ID}/release/${GROUP_ID}/${ARTIFACT_ID}/${VERSION}/${ARTIFACT_ID}-${VERSION}.${PACKAGING}"
echo "Uploading to Consul key [${CONSUL_KEY}]....Artifact URL [${URL}"]
curl -X PUT -d ${URL} http://${CONSUL_HOST}:${CONSUL_PORT}/v1/kv/${CONSUL_KEY}
echo "Finished: $(date)"