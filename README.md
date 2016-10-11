# hashicorp-demo

This project is designed to show how the different parts of the Hashicorp product set can work together.

To execute this project you will need to run the projects in order.

1. [Create the Java SpingBoot Application](./application-springboot).

    Make a note of the the following, used in the terraform project:

      * Application URL

2. [Create the AMI using Packer](./packer).

    Make a note of the the following, used in the terrafotm projects:

      * AMI ID
      
3.[Create the Consul, Vault and Nomad Server and Client Cluster](./terraform).
    
    Set the Application URL and AMI IDs in the variables of the terraform modules.