output "NAME" {
  value = "${local.name}"
}

output "ETCD_NAMES" {
  value = "${scaleway_server.etcd.*.name}"
}

output "ETCD_SSH_IPS" {
  value = "${scaleway_server.etcd.*.public_ip}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${scaleway_server.etcd.*.private_ip}"
}

output "CONTROLLER_NAMES" {
  value = "${scaleway_server.controller.*.name}"
}

output "CONTROLLER_SSH_IPS" {
  value = "${scaleway_server.controller.*.public_ip}"
}

output "CONTROLLER_PRIVATE_IPS" {
  value = "${scaleway_server.controller.*.private_ip}"
}

output "NODE_SSH_IPS" {
  value = "${scaleway_server.node.*.public_ip}"
}

output "NODE_PRIVATE_IPS" {
  value = "${scaleway_server.node.*.private_ip}"
}

output "NODE_NAMES" {
  value = "${scaleway_server.node.*.name}"
}
