variable "ami" {
    description = "AWS AMI Id"
}

variable "server_count" {
    default = "3"
    description = "The number of Hashi servers to launch."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
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
}

variable "key_path" {
    description = "Path to the private key specified by key_name."
}

variable "tagName" {
    default = "hashi-demo"
    description = "Name tag for the servers"
}

variable "app_download_url" {
    description = "URL to Java Application JAR file."
}

variable "vault_app_name" {
    description = "Vault application name."
    default = "hashiapp-demo"
}

variable "vault_app_password" {
    description = "Vault application password."
}
