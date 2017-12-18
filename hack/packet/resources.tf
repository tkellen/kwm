provider "packet" {}

locals {
  name = "packet"
  cidr = "10.100.0.0/16"
  etcd_count = 1
  controller_count = 1
  node_count = 2
}

resource "packet_ssh_key" "ssh" {
  name = "${local.name}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "packet_project" "main" {
  name = "${local.name}"
}

resource "packet_device" "etcd" {
  count = "${local.etcd_count}"
  hostname = "${local.name}-etcd-${count.index}"
  plan = "baremetal_0"
  facility = "ewr1"
  operating_system = "ubuntu_16_04"
  billing_cycle = "hourly"
  project_id = "${packet_project.main.id}"
}

resource "packet_device" "controller" {
  count = "${local.controller_count}"
  hostname = "${local.name}-controller-${count.index}"
  plan = "baremetal_0"
  facility = "ewr1"
  operating_system = "ubuntu_16_04"
  billing_cycle = "hourly"
  project_id = "${packet_project.main.id}"
}

resource "packet_device" "node" {
  count = "${local.node_count}"
  hostname = "${local.name}-node-${count.index}"
  plan = "baremetal_0"
  facility = "ewr1"
  operating_system = "ubuntu_16_04"
  billing_cycle = "hourly"
  project_id = "${packet_project.main.id}"
}
