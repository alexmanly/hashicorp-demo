provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "hashi-servers" {
  source = "./modules/hashi-servers"
}

module "hashi-clients" {
  source = "./modules/hashi-clients"

  consul_dns = "${module.hashi-servers.consul_dns}"
}
