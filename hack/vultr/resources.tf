provider "vultr" { }

locals {
  name = "vultr"
  etcd_count = 1
  controller_count = 1
  node_count = 2
}

data "vultr_region" "atlanta" {
  filter {
    name = "name"
    values = ["Atlanta"]
  }
}

data "vultr_os" "ubuntu" {
  name_regex = "Ubuntu 16.04 x64"
}

data "vultr_plan" "starter" {
  filter {
    name   = "price_per_month"
    values = ["10.00"]
  }

  filter {
    name   = "ram"
    values = ["2048"]
  }
}

data "vultr_ssh_key" "main" {
  filter {
    name   = "name"
    values = ["kwm"]
  }
}

resource "vultr_firewall_group" "main" {
  description = "${local.name}"
}

resource "vultr_firewall_rule" "ssh" {
  firewall_group_id = "${vultr_firewall_group.main.id}"
  cidr_block = "0.0.0.0/0"
  protocol = "tcp"
  from_port = 22
  to_port = 22
}

resource "vultr_firewall_rule" "https" {
  firewall_group_id = "${vultr_firewall_group.main.id}"
  cidr_block = "0.0.0.0/0"
  protocol = "tcp"
  from_port = 443
  to_port = 443
}

resource "vultr_firewall_rule" "http" {
  firewall_group_id = "${vultr_firewall_group.main.id}"
  cidr_block = "0.0.0.0/0"
  protocol = "tcp"
  from_port = 80
  to_port = 80
}

resource "vultr_firewall_rule" "icmp" {
  firewall_group_id = "${vultr_firewall_group.main.id}"
  cidr_block = "0.0.0.0/0"
  protocol = "icmp"
}

resource "vultr_instance" "etcd" {
  count = "${local.etcd_count}"
  name = "${local.name}-etcd-${count.index}"
  hostname = "${local.name}-etcd-${count.index}"
  region_id = "${data.vultr_region.atlanta.id}"
  plan_id = "${data.vultr_plan.starter.id}"
  os_id = "${data.vultr_os.ubuntu.id}"
  firewall_group_id = "${vultr_firewall_group.main.id}"
  ssh_key_ids = ["${data.vultr_ssh_key.main.id}"]
  private_networking = true
}

resource "vultr_instance" "controller" {
  count = "${local.node_count}"
  name = "${local.name}-controller-${count.index}"
  hostname = "${local.name}-controller-${count.index}"
  region_id = "${data.vultr_region.atlanta.id}"
  plan_id = "${data.vultr_plan.starter.id}"
  os_id = "${data.vultr_os.ubuntu.id}"
  firewall_group_id = "${vultr_firewall_group.main.id}"
  ssh_key_ids = ["${data.vultr_ssh_key.main.id}"]
  private_networking = true
}

resource "vultr_instance" "node" {
  count = "${local.node_count}"
  name = "${local.name}-node-${count.index}"
  hostname = "${local.name}-node-${count.index}"
  region_id = "${data.vultr_region.atlanta.id}"
  plan_id = "${data.vultr_plan.starter.id}"
  os_id = "${data.vultr_os.ubuntu.id}"
  firewall_group_id = "${vultr_firewall_group.main.id}"
  ssh_key_ids = ["${data.vultr_ssh_key.main.id}"]
  private_networking = true
}
