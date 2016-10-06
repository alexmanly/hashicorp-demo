variable "access_key" {
    description = "AWS access key id."
}

variable "secret_key" {
    description = "AWS secret access key."
}

variable "platform" {
    default = "ubuntu"
    description = "The OS Platform"
}

variable "user" {
    default = "ubuntu"
}

variable "ami" {
    description           = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "
    default = {
        us-east-1-ubuntu  = "ami-fce3c696"
        us-west-2-ubuntu  = "ami-9abea4fb"
        eu-west-1-ubuntu = "ami-47a23a30"
        eu-central-1-ubuntu = "ami-accff2b1"
        ap-northeast-1-ubuntu = "ami-90815290"
        ap-southeast-1-ubuntu = "ami-0accf458"
        ap-southeast-2-ubuntu = "ami-1dc8b127"
    }
}

variable "consul_service_conf" {
  default = "consul_upstart.conf"
}

variable "consul_agent_conf" {
  default = "consul_config.json"
}

variable "consul_agent_env" {
  default = "consul.env"
}

variable "nomad_service_conf" {
  default = "nomad_upstart.conf"
}

variable "nomad_agent_conf" {
  default = "nomad_config.json"
}

variable "nomad_agent_env" {
  default = "nomad.env"
}

variable "vault_service_conf" {
  default = "vault_upstart.conf"
}

variable "vault_agent_conf" {
  default = "vault_config.json"
}

variable "vault_agent_env" {
  default = "vault.env"
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
    default = "3"
    description = "The number of Hashi servers to launch."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
    default = "hashi-servers"
    description = "Name tag for the servers"
}
