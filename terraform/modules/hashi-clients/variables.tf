variable "consul_dns" {
    description = "Consul DNS."
}

variable "app_download_url" {
    description = "URL to Java Application JAR file."
}

variable "app_install_path" {
    description = "Intallation path for the Java Application"
    default = "/opt/java_hashidemo"
}

variable "app_port" {
    description = "Port for the Java Application"
    default = 8090
}

variable "vault_app_name" {
    description = "Vault application name."
    default = "hashiapp-demo"
}

variable "ami" {
    description = "AWS AMI Id"
}

variable "subnet_id" {
    description = "AWS Subnet ID"
    default = "subnet-d16c3cfb"
}

variable "server_instance_ips" {
  default = ["172.31.50.150", "172.31.50.151", "172.31.50.152"]
}

variable "client_instance_ips" {
  default = ["172.31.60.150", "172.31.60.151", "172.31.60.152"]
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

variable "server_count" {
    default = "3"
    description = "The number of Hashi servers to launch."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
    default = "hashi-demo"
    description = "Name tag for the servers"
}
