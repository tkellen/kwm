# To use, export DIGITALOCEAN_TOKEN=<your token>
provider "digitalocean" { }

locals {
  name = "digitalocean"
  cidr = "10.100.0.0/16"
  etcd_count = 1
  controller_count = 1
  node_count = 1
  ssh_key_fingerprint = "63:6f:87:9d:e0:89:e6:e7:27:81:e7:85:37:22:fe:6b"
  subnetCidrs = [
    "${cidrsubnet(local.cidr, 8, 0)}",
    "${cidrsubnet(local.cidr, 8, 1)}",
    "${cidrsubnet(local.cidr, 8, 2)}"
  ]
}

output "NAME" {
  value = "${local.name}"
}

output "ETCD_NAMES" {
  value = "${digitalocean_droplet.etcd.*.name}"
}

output "ETCD_SSH_IPS" {
  value = "${digitalocean_droplet.etcd.*.ipv4_address}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${digitalocean_droplet.etcd.*.ipv4_address_private}"
}

output "CONTROLLER_NAMES" {
  value = "${digitalocean_droplet.controller.*.name}"
}

output "CONTROLLER_SSH_IPS" {
  value = "${digitalocean_droplet.controller.*.ipv4_address}"
}

output "CONTROLLER_PRIVATE_IPS" {
  value = "${digitalocean_droplet.controller.*.ipv4_address_private}"
}

output "NODE_SSH_IPS" {
  value = "${digitalocean_droplet.node.*.ipv4_address}"
}

output "NODE_PRIVATE_IPS" {
  value = "${digitalocean_droplet.node.*.ipv4_address_private}"
}

output "NODE_NAMES" {
  value = "${digitalocean_droplet.node.*.name}"
}

output "LOAD_BALANCER_SSH_IPS" {
  value = "${digitalocean_droplet.controller.*.ipv4_address}"
}

output "LOAD_BALANCER_PUBLIC_IPS" {
  value = "${digitalocean_droplet.controller.*.ipv4_address}"
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
