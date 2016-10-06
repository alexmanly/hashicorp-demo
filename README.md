# hashicorp-demo

This project is designed to show how the different parts of the Hashicorp product set can work together.

To execute this project you will need to run the projects in order.

1. [Create the Consul, Vault and Nomad Server Cluster](./terraform-hashi-servers).
    
    Make a note of the the following, used in the next projects:  
    CONSUL_HOST  - e.g. "ec2-10-10-10-10.compute-1.amazonaws.com"  
    VAULT_HOST   - e.g. "ec2-10-10-10-10.compute-1.amazonaws.com"  
    VAULT_TOKEN  - e.g. "123abcd4-ef5g-6h78-9ij0-k1234l567m89"  
    NOMAD_1_HOST - e.g. "ec2-10-10-10-10.compute-1.amazonaws.com"  
    NOMAD_2_HOST - e.g. "ec2-20-20-20-20.compute-1.amazonaws.com"  
    NOMAD_3_HOST - e.g. "ec2-30-30-30-30.compute-1.amazonaws.com"  
    
2. [Create the Java Tomcat Web Application](./application).
3. [Create the Java SpingBoot Application](./application-springboot).
4. [Create the AMI using Packer](./packer).
5. [Create the Appliction Cluster using Terraform, Consul, Vault and Nomad](./terraform-hashi-clients).