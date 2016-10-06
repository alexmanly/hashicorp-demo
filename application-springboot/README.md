# HashiApp Springboot Demo Java Application

This folder contains files to build a demo Java application, which is used
in the HashiApp demo.  It is a [Springboot](http://projects.spring.io/spring-boot/) Java application that exposes a number of REST endpoints. 

## Build the Application
This is a Java application that uses Maven to complile the code and build the JAR file.  Install [maven](https://maven.apache.org/install.html) version 3.3+. Install [Java](https://java.com/en/download/) version 8.

```bash
mvn clean install
```

## Deploy the Application to S3
If you would like to deploy the JAR file to an AWS S3 bucket then you need to configure maven.  Follow these [instructions](http://www.yegor256.com/2015/09/07/maven-repository-amazon-s3.html).  Then run this command to upload the WAR file to your S3 bucket.

```bash
mvn deploy
```

## Upload the Application URL to Consul
If you would like to store the location of the JAR file URL in Consul then run these commands:

```bash
mvn clean install deploy
export CONSUL_ADDR="REDACTED"
export CONSUL_KEY="service/app/my_app"
export AWS_REGION="us-west-2"
export VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[')
export GROUP_ID=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.groupId | grep -v '\[' | sed s@[.]@/@g)
export ARTIFACT_ID=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.artifactId | grep -v '\[')
export PACKAGING=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.packaging | grep -v '\[')
export URL="https://s3-${AWS_REGION}.amazonaws.com/${ARTIFACT_ID}/release/${GROUP_ID}/${ARTIFACT_ID}/${VERSION}/${ARTIFACT_ID}-${VERSION}.${PACKAGING}"
echo "Uploading to Consul key [${CONSUL_KEY}]....Artifact URL [${URL}"]
curl -X PUT -d ${URL} http://${CONSUL_ADDR}/v1/kv/${CONSUL_KEY}
```

## Run the Application
This application required a couple of enviroment variables to be set for the application to run successfully.  Set these environment variables in the shell that you will run the Java application from:

| NAME        | VALUE                                  |
| ----------- | -------------------------------------- |
| VAULT_ADDR  | http://IP-ADDRESS-OF-VAULT-SERVER:8500 |
| VAULT_TOKEN | REDACTED                               |

Run this command to run the application

```bash
export VAULT_ADDR="MY VAULT SERVER"
export VAULT_TOKEN="MY VAULT TOKEN"
java -jar <PATH to JAR file>
```

This application is configured to run on port 8090.  To change this port change the value in the [application.properties](./src/main/resources/application.properties) file.

## Test the Application
The exposed endpoints are:

| Rest Endpoint                                   | 
| ----------------------------------------------- |
| http://localhost:8090/hello                     |
| http://localhost:8090/hello/{name}              |
| http://localhost:8090/version                   |
| http://localhost:8090/vault/{path1}/{path2}     |
| http://localhost:8090/hashiapp-demo/rest/health |


