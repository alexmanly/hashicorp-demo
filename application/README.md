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
Run this command to run the application

```bash
java -jar <PATH to JAR file>
/usr/bin/java -jar <PATH to JAR file> --spring.config.location=<PATH to JAR config dir>/ >>/var/log/java_app.log 2>&1
```

This application is configured to run on port 8090.  To change this port change the value in the [application.properties](./application.properties) file.  Configure the Vault settings in the bootstrap.properties](./bootstrap.properties) file.  These files should be located in the *spring.config.location* directory.

## Test the Application
The exposed endpoints are:

| Rest Endpoint                                   | 
| ----------------------------------------------- |
| http://localhost:8090/hello                     |
| http://localhost:8090/hello/{name}              |
| http://localhost:8090/version                   |
| http://localhost:8090/vault                     |
| http://localhost:8090/hashiapp-demo/rest/health |


