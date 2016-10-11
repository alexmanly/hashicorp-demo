provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "hashi-servers" {
  source = "./modules/hashi-servers"

  vault_app_password = "${var.vault_app_password}"
  app_download_url = "${var.app_download_url}"
}

module "hashi-clients" {
  source = "./modules/hashi-clients"

  consul_dns = "${module.hashi-servers.consul_dns}"
  app_download_url = "${var.app_download_url}"
}
