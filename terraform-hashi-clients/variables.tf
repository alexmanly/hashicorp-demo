variable "access_key" {
    description = "AWS access key id."
}

variable "secret_key" {
    description = "AWS secret access key."
}

variable "consul" {
    description = "Consul private IP address."
}

variable "nomad_1" {
    description = "Nomad 1 private IP address."
}

variable "nomad_2" {
    description = "Nomad 2 private IP address."
}

variable "nomad_3" {
    description = "Nomad 3 private IP address."
}

variable "vault_addr" {
    description = "Vault adress for the application."
}

variable "vault_token" {
    description = "Vault token for the application."
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

variable "region" {
    default = "us-east-1"
    description = "The region of AWS, for AMI lookups."
}

variable "servers" {
    default = "1"
    description = "The number of Hashi clients to launch."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
    default = "hashi-clients"
    description = "Name tag for the servers"
}
