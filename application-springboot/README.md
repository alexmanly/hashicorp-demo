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

This application is configured to run on port 8090.  To change this port change the value in the [application.properties](./src/main/java/resources/application.properties) file.

## Test the Application
The exposed endpoints are:

| Rest Endpoint                                   | 
| ----------------------------------------------- |
| http://localhost:8090/hello                     |
| http://localhost:8090/hello/{name}              |
| http://localhost:8090/version                   |
| http://localhost:8090/vault/{path1}/{path2}     |
| http://localhost:8090/hashiapp-demo/rest/health |


