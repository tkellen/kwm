provider "triton" {}

locals {
  name = "triton"
  cidr = "10.100.0.0/16"
  etcd_count = 1
  controlplane_count = 1
  worker_count = 2
}

data "triton_image" "ubuntu" {
  name = "ubuntu-16.04"
  version = "20170403"
}

data "triton_network" "main" {
  name = "Joyent-SDC-Public"
}

resource "triton_vlan" "main" {
  vlan_id = 100
  name = "${local.name}"
}

resource "triton_fabric" "main" {
  vlan_id = "${triton_vlan.main.id}"
  name = "${local.name}"
  subnet = "${local.cidr}"
  provision_start_ip = "${cidrhost(local.cidr, 10)}"
  provision_end_ip = "${cidrhost(local.cidr, 240)}"
  gateway = "${cidrhost(local.cidr, 1)}"
  resolvers = ["8.8.8.8", "8.8.4.4"]
  internet_nat = true
}

resource "triton_machine" "etcd" {
  count = "${local.etcd_count}"
  name = "${local.name}-etcd-${count.index}"
  package = "g4-general-4G"
  image = "${data.triton_image.ubuntu.id}"
  root_authorized_keys = "${file("~/.ssh/id_rsa.pub")}"
  networks = [
    "${data.triton_network.main.id}",
    "${triton_fabric.main.id}"
  ]
}

resource "triton_machine" "controlplane" {
  count = "${local.controlplane_count}"
  name = "${local.name}-controlplane-${count.index}"
  package = "g4-general-4G"
  image = "${data.triton_image.ubuntu.id}"
  root_authorized_keys = "${file("~/.ssh/id_rsa.pub")}"
  networks = [
    "${data.triton_network.main.id}",
    "${triton_fabric.main.id}"
  ]
}

resource "triton_machine" "worker" {
  count = "${local.worker_count}"
  name = "${local.name}-worker-${count.index}"
  package = "g4-general-4G"
  image = "${data.triton_image.ubuntu.id}"
  root_authorized_keys = "${file("~/.ssh/id_rsa.pub")}"
  networks = [
    "${data.triton_network.main.id}",
    "${triton_fabric.main.id}"
  ]
}
