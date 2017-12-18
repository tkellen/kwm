provider "scaleway" {
  region = "par1"
}

locals {
  name = "scaleway"
  etcd_count = 1
  controller_count = 1
  node_count = 2
}

data "scaleway_image" "ubuntu" {
  architecture = "x86_64"
  name = "Ubuntu Xenial"
}

resource "scaleway_security_group" "main" {
  name = "http"
  description = "allow HTTP and HTTPS traffic"
}

resource "scaleway_security_group_rule" "ssh" {
  security_group = "${scaleway_security_group.main.id}"
  action = "accept"
  direction = "inbound"
  ip_range = "0.0.0.0/0"
  protocol = "TCP"
  port = 22
}

resource "scaleway_security_group_rule" "https" {
  security_group = "${scaleway_security_group.main.id}"
  action = "accept"
  direction = "inbound"
  ip_range = "0.0.0.0/0"
  protocol = "TCP"
  port = 443
}

resource "scaleway_security_group_rule" "http" {
  security_group = "${scaleway_security_group.main.id}"
  action = "accept"
  direction = "inbound"
  ip_range = "0.0.0.0/0"
  protocol = "TCP"
  port = 80
}

resource "scaleway_security_group_rule" "icmp" {
  security_group = "${scaleway_security_group.main.id}"
  action = "accept"
  direction = "inbound"
  ip_range = "0.0.0.0/0"
  protocol = "ICMP"
}

resource "scaleway_server" "etcd" {
  count = "${local.etcd_count}"
  name = "${local.name}-etcd-${count.index}"
  security_group = "${scaleway_security_group.main.id}"
  image = "${data.scaleway_image.ubuntu.id}"
  dynamic_ip_required = true
  type  = "C2S"
  volume {
    size_in_gb = 20
    type = "l_ssd"
  }
}

resource "scaleway_server" "controller" {
  count = "${local.etcd_count}"
  name = "${local.name}-controller-${count.index}"
  security_group = "${scaleway_security_group.main.id}"
  image = "${data.scaleway_image.ubuntu.id}"
  dynamic_ip_required = true
  type = "C2S"
  volume {
    size_in_gb = 20
    type = "l_ssd"
  }
}

resource "scaleway_server" "node" {
  count = "${local.node_count}"
  name = "${local.name}-node-${count.index}"
  security_group = "${scaleway_security_group.main.id}"
  image = "${data.scaleway_image.ubuntu.id}"
  dynamic_ip_required = true
  type  = "C2S"
  volume {
    size_in_gb = 20
    type = "l_ssd"
  }
}
