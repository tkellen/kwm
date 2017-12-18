output "NAME" {
  value = "${local.name}"
}

output "ETCD_NAMES" {
  value = "${packet_device.etcd.*.hostname}"
}

output "ETCD_SSH_IPS" {
  value = "${packet_device.etcd.*.access_public_ipv4}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${packet_device.etcd.*.access_private_ipv4}"
}

output "CONTROLLER_NAMES" {
  value = "${packet_device.controller.*.hostname}"
}

output "CONTROLLER_SSH_IPS" {
  value = "${packet_device.controller.*.access_public_ipv4}"
}

output "CONTROLLER_PRIVATE_IPS" {
  value = "${packet_device.controller.*.access_private_ipv4}"
}

output "NODE_SSH_IPS" {
  value = "${packet_device.node.*.access_public_ipv4}"
}

output "NODE_PRIVATE_IPS" {
  value = "${packet_device.node.*.access_private_ipv4}"
}

output "NODE_NAMES" {
  value = "${packet_device.node.*.hostname}"
}

output "LOAD_BALANCER_SSH_IPS" {
  value = "${packet_device.controller.*.access_public_ipv4}"
}

output "LOAD_BALANCER_PUBLIC_IPS" {
  value = "${packet_device.controller.*.access_public_ipv4}"
}
