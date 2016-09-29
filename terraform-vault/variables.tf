//-------------------------------------------------------------------
// Vault settings
//-------------------------------------------------------------------

variable "download-url" {
    default = "https://releases.hashicorp.com/vault/0.6.1/vault_0.6.1_linux_amd64.zip"
    description = "URL to download Vault"
}

variable "consul-url" {
    description = "URL to Consul"
}

variable "config" {
    description = "Configuration (text) for Vault"
    default = <<EOF
backend "consul" {
  address = "${consul-url}"
  path = "vault"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

telemetry {
  statsite_address = "127.0.0.1:8125"
  disable_hostname = true
}
EOF
}

variable "extra-install" {
    default = ""
    description = "Extra commands to run in the install script"
}

//-------------------------------------------------------------------
// AWS settings
//-------------------------------------------------------------------

variable "access_key" {
    description = "AWS access key id."
}

variable "secret_key" {
    description = "AWS secret access key."
}

variable "region" {
    default = "us-east-1"
    description = "The region of AWS, for AMI lookups."
}

variable "ami" {
    default = "ami-7eb2a716"
    description = "AMI for Vault instances"
}

variable "availability-zones" {
    default = "us-east-1a,us-east-1c"
    description = "Availability zones for launching the Vault instances"
}

variable "elb-health-check" {
    default = "HTTP:8200/v1/sys/health"
    description = "Health check for Vault servers"
}

variable "instance_type" {
    default = "m3.medium"
    description = "Instance type for Vault instances"
}

variable "key-name" {
    default = "amanly-vault"
    description = "SSH key name for Vault instances"
}

variable "nodes" {
    default = "1"
    description = "number of Vault instances"
}

variable "subnets" {
    description = "list of subnets to launch Vault within"
    default = "subnet-4c742914,subnet-d16c3cfb"
}

variable "vpc-id" {
    description = "VPC ID"
    default = "vpc-9ae85cfd"
}
