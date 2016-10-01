#!/usr/bin/env bash
set -e

echo "Started: $(date)"
echo "Please, enter the S3 buckt name"
read S3_BUCKET
echo "Compiling Application and Generating WAR file"
mvn clean install
echo "Uploading WAR file to s3"
export AWS_ACCESS_KEY_ID=$(sed "2q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
export AWS_SECRET_ACCESS_KEY=$(sed "3q;d" ~/.aws/credentials | awk -F'=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
aws s3 cp ./target/hashiapp-demo-0.0.1-SNAPSHOT.war s3://$S3_BUCKET/snapshot/com/amanly/hashiapp-demo/0.0.1-SNAPSHOT/hashiapp-demo-0.0.1-SNAPSHOT.war --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
echo "Finished: $(date)"
