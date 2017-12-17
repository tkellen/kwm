# Setup:
# export TRITON_ACCOUNT=<your account name>
# export TRITON_KEY_ID=${$(ssh-keygen -l -E md5 -f ~/.ssh/id_rsa.pub | awk '{print $2}')#MD5:}
# ^ assuming you have associted your default keypair with your triton account
provider "triton" {}

data "triton_image" "ubuntu" {
  name = "ubuntu-16.04"
  version = "20170403"
}

data "triton_network" "main" {
  name = "Joyent-SDC-Public"
}

locals {
  name = "triton"
  cidr = "10.100.0.0/16"
  etcd_count = 1
  controller_count = 1
  node_count = 2
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

resource "triton_machine" "controller" {
  count = "${local.controller_count}"
  name = "${local.name}-controller-${count.index}"
  package = "g4-general-4G"
  image = "${data.triton_image.ubuntu.id}"
  root_authorized_keys = "${file("~/.ssh/id_rsa.pub")}"
  networks = [
    "${data.triton_network.main.id}",
    "${triton_fabric.main.id}"
  ]
}

resource "triton_machine" "node" {
  count = "${local.node_count}"
  name = "${local.name}-node-${count.index}"
  package = "g4-general-4G"
  image = "${data.triton_image.ubuntu.id}"
  root_authorized_keys = "${file("~/.ssh/id_rsa.pub")}"
  networks = [
    "${data.triton_network.main.id}",
    "${triton_fabric.main.id}"
  ]
}
