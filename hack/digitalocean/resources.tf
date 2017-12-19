provider "digitalocean" { }

locals {
  name = "digitalocean"
  cidr = "10.100.0.0/16"
  etcd_count = 1
  controlplane_count = 1
  worker_count = 2
  ssh_key_fingerprint = "63:6f:87:9d:e0:89:e6:e7:27:81:e7:85:37:22:fe:6b"
}

resource "digitalocean_droplet" "etcd" {
  count = "${local.etcd_count}"
  name = "${local.name}-etcd-${count.index}"
  image = "ubuntu-16-04-x64"
  size = "4gb"
  region = "nyc1"
  private_networking = true
  ipv6 = true
  ssh_keys = ["${local.ssh_key_fingerprint}"]
}

resource "digitalocean_droplet" "controlplane" {
  count = "${local.controlplane_count}"
  name = "${local.name}-controlplane-${count.index}"
  image = "ubuntu-16-04-x64"
  size = "4gb"
  region = "nyc1"
  private_networking = true
  ipv6 = true
  ssh_keys = ["${local.ssh_key_fingerprint}"]
}

resource "digitalocean_droplet" "worker" {
  count = "${local.worker_count}"
  name = "${local.name}-worker-${count.index}"
  image = "ubuntu-16-04-x64"
  size = "1gb"
  region = "nyc1"
  private_networking = true
  ipv6 = true
  ssh_keys = ["${local.ssh_key_fingerprint}"]
}
