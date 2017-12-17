# Setup:
# export DIGITALOCEAN_TOKEN=<your token>
provider "digitalocean" { }

locals {
  name = "digitalocean"
  cidr = "10.100.0.0/16"
  etcd_count = 1
  controller_count = 1
  node_count = 2
  ssh_key_fingerprint = "63:6f:87:9d:e0:89:e6:e7:27:81:e7:85:37:22:fe:6b"
}

resource "digitalocean_droplet" "etcd" {
  count = "${local.etcd_count}"
  name = "${local.name}-etcd-${count.index}"
  image = "ubuntu-16-04-x64"
  size = "4gb"
  region = "nyc1"
  private_networking = true
  ssh_keys = ["${local.ssh_key_fingerprint}"]
}

resource "digitalocean_droplet" "controller" {
  count = "${local.controller_count}"
  name = "${local.name}-controller-${count.index}"
  image = "ubuntu-16-04-x64"
  size = "4gb"
  region = "nyc1"
  private_networking = true
  ssh_keys = ["${local.ssh_key_fingerprint}"]
}

resource "digitalocean_droplet" "node" {
  count = "${local.node_count}"
  name = "${local.name}-node-${count.index}"
  image = "ubuntu-16-04-x64"
  size = "1gb"
  region = "nyc1"
  private_networking = true
  ssh_keys = ["${local.ssh_key_fingerprint}"]
}
