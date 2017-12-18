output "NAME" {
  value = "${local.name}"
}

output "ETCD_NAMES" {
  value = "${vultr_instance.etcd.*.name}"
}

output "ETCD_SSH_IPS" {
  value = "${vultr_instance.etcd.*.ipv4_address}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${vultr_instance.etcd.*.ipv4_private_address}"
}

output "CONTROLLER_NAMES" {
  value = "${vultr_instance.controller.*.name}"
}

output "CONTROLLER_SSH_IPS" {
  value = "${vultr_instance.controller.*.ipv4_address}"
}

output "CONTROLLER_PRIVATE_IPS" {
  value = "${vultr_instance.controller.*.ipv4_private_address}"
}

output "NODE_SSH_IPS" {
  value = "${vultr_instance.node.*.ipv4_address}"
}

output "NODE_PRIVATE_IPS" {
  value = "${vultr_instance.node.*.ipv4_private_address}"
}

output "NODE_NAMES" {
  value = "${vultr_instance.node.*.name}"
}

output "LOAD_BALANCER_SSH_IPS" {
  value = "${vultr_instance.controller.*.ipv4_address}"
}

output "LOAD_BALANCER_PUBLIC_IPS" {
  value = "${vultr_instance.controller.*.ipv4_address}"
}
