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