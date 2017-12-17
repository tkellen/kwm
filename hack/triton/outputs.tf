output "NAME" {
  value = "${local.name}"
}

output "ETCD_NAMES" {
  value = "${triton_machine.etcd.*.name}"
}

output "ETCD_SSH_IPS" {
  value = "${triton_machine.etcd.*.primaryip}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${triton_machine.etcd.*.ips.1}"
}

output "CONTROLLER_NAMES" {
  value = "${triton_machine.controller.*.name}"
}

output "CONTROLLER_SSH_IPS" {
  value = "${triton_machine.controller.*.primaryip}"
}

output "CONTROLLER_PRIVATE_IPS" {
  value = "${triton_machine.controller.*.ips.1}"
}

output "NODE_SSH_IPS" {
  value = "${triton_machine.node.*.primaryip}"
}

output "NODE_PRIVATE_IPS" {
  value = "${triton_machine.node.*.ips.1}"
}

output "NODE_NAMES" {
  value = "${triton_machine.node.*.name}"
}

output "LOAD_BALANCER_SSH_IPS" {
  value = "${triton_machine.controller.*.primaryip}"
}

output "LOAD_BALANCER_PUBLIC_IPS" {
  value = "${triton_machine.controller.*.primaryip}"
}
