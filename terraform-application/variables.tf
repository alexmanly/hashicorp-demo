variable "access_key" {
    description = "AWS access key id."
}

variable "secret_key" {
    description = "AWS secret access key."
}

variable "consul" {
    description = "Address for Consul."
}

variable "vault_token" {
    description = "Vault token."
}

variable "user" {
    description = "User to SSH in the node with."
    default = "ec2-user"
}

variable "project" {
    description = "Project Name."
    default = "hashiapp_demo"
}

variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
    default = "amanly-vault"
}

variable "key_path" {
    description = "Path to the private key specified by key_name."
    default = "/Users/alex/.ssh/amanly-vault.pem"
}

variable "region" {
    default = "us-east-1"
    description = "The region of AWS, for AMI lookups."
}

variable "servers" {
    default = "1"
    description = "The number of Consul servers to launch."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}