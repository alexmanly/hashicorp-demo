# HashiApp Demo Java Application

This folder contains files to build a demo Java web application, which is used
in the HashiApp demo.  It is a JAX-RS [Jersey](https://jersey.java.net/) application that exposes a number of REST endpoints. 

## Build the Application
This is a Java web application that uses Maven to complile the code and build the WAR file.  Install [maven](https://maven.apache.org/install.html) version 3.3+. Install [Java](https://java.com/en/download/) version 8.

```bash
mvn clean install
```

## Deploy the Application to S3
If you would like to deploy the WAR file to an AWS S3 bucket then you need to configure maven.  Follow these [instructions](http://www.yegor256.com/2015/09/07/maven-repository-amazon-s3.html).  Then run this command to upload the WAR file to your S3 bucket.

```bash
mvn deploy
```

## Upload the Application URL to Consul
If you would like to store the location of the WAR file URL in Consul then run these commands:

```bash
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
```

## Run the Application
Install the WAR file into a [Tomcat](https://tomcat.apache.org/) container in the webapps directory.  This application required a couple of enviroment variables to be set for the application to run successfully.  Set these environment variables in the shell that you will run the Tomcat container in:

| NAME        | VALUE                                  |
| ------------| -------------------------------------- |
| VAULT_ADDR  | http://IP-ADDRESS-OF-VAULT-SERVER:8500 |
| VAULT_TOKEN | REDACTED                               |

Now start tomcat:

```bash
export VAULT_ADDR="MY VAULT SERVER"
export VAULT_TOKEN="MY VAULT TOKEN"
./<Tomcat Path>/bin/startup.sh
```

By default Tomcat exposes the port 8080.

## Test the Application
The exposed endpoints are:

| Rest Endpoint                                                  | 
| -------------------------------------------------------------- |
| http://localhost:8080/hashiapp-demo/rest/hello                 |
| http://localhost:8080/hashiapp-demo/rest/hello/{name}          |
| http://localhost:8080/hashiapp-demo/rest/version               |
| http://localhost:8080/hashiapp-demo/rest/vault/{path1}/{path2} |
| http://localhost:8080/hashiapp-demo/rest/health                |
| http://localhost:8080/hashiapp-demo/rest/health/toggle         |
| http://localhost:8080/hashiapp-demo/rest/health/on             |
| http://localhost:8080/hashiapp-demo/rest/health/off            |


