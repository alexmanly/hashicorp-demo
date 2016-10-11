variable "ami" {
    description = "AWS AMI Id"
    default = "ami-67286670"
}

variable "subnet_id" {
    description = "AWS Subnet ID"
    default = "subnet-d16c3cfb"
}

variable "server_count" {
    default = "3"
    description = "The number of Hashi servers to launch."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "server_instance_ips" {
  default = ["172.31.50.150", "172.31.50.151", "172.31.50.152"]
}

variable "platform" {
    default = "ubuntu"
    description = "The OS Platform"
}

variable "user" {
    default = "ubuntu"
}

variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
    default = "amanly-vault"
}

variable "key_path" {
    description = "Path to the private key specified by key_name."
    default = "/Users/alex/.ssh/amanly-vault.pem"
}

variable "tagName" {
    default = "hashi-demo"
    description = "Name tag for the servers"
}

variable "javaapp_jar_url" {
    description = "URL to the JAR file to application."
    default = "https://s3-us-west-2.amazonaws.com/hashiapp-springboot-demo/release/com/amanly/hashiapp-springboot-demo/1.0.0/hashiapp-springboot-demo-1.0.0.jar"
}

variable "vault_app_password" {
    description = "Vault application password."
}

variable "vault_app_name" {
    description = "Vault application name."
    default = "hashiapp-demo"
}
