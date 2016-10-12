provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "hashi-servers" {
  source = "./modules/hashi-servers"

  ami								 = "${var.ami}"
  vault_app_password = "${var.vault_app_password}"
  app_download_url   = "${var.app_download_url}"
  key_name           = "${var.key_name}"
  key_path           = "${var.key_path}"
}

module "hashi-clients" {
  source = "./modules/hashi-clients"

  ami							 = "${var.ami}"
  consul_dns       = "${module.hashi-servers.consul_dns}"
  app_download_url = "${var.app_download_url}"
  key_name         = "${var.key_name}"
  key_path         = "${var.key_path}"
}
