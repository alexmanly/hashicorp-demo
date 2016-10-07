# hashicorp-demo

This project is designed to show how the different parts of the Hashicorp product set can work together.

To execute this project you will need to run the projects in order.

1. [Create the Consul, Vault and Nomad Server Cluster](./terraform-hashi-servers).
    
    Make a note of the the following, used in the next projects: 

      * CONSUL_HOST  - e.g. "ec2-10-10-10-10.compute-1.amazonaws.com"  

    Initialise and unseal Vault:  

      * ssh ubuntu@ec2-10-10-10-10.compute-1.amazonaws.com
      * vault init
      * vault unseal <key1>  
      * vault unseal <key2>  
      * vault unseal <key3>  

    Make note of the Vault Token:  
    
      * VAULT_TOKEN  - e.g. "123abcd4-ef5g-6h78-9ij0-k1234l567m89"   
    
2. [Create the Java Tomcat Web Application](./application).
3. [Create the Java SpingBoot Application](./application-springboot).
4. [Create the AMI using Packer](./packer).
5. [Create the Appliction Cluster using Terraform, Consul, Vault and Nomad](./terraform-hashi-clients).