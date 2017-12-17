output "NAME" {
  value = "${local.name}"
}

output "ETCD_NAMES" {
  value = "${azurerm_virtual_machine.etcd.*.name}"
}

output "ETCD_SSH_IPS" {
  value = "${azurerm_public_ip.etcd.*.ip_address}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${azurerm_network_interface.etcd.*.private_ip_address}"
}

output "CONTROLLER_NAMES" {
  value = "${azurerm_virtual_machine.controller.*.name}"
}

output "CONTROLLER_SSH_IPS" {
  value = "${azurerm_public_ip.controller.*.ip_address}"
}

output "CONTROLLER_PRIVATE_IPS" {
  value = "${azurerm_network_interface.node.*.private_ip_address}"
}

output "NODE_NAMES" {
  value = "${azurerm_virtual_machine.node.*.name}"
}

output "NODE_SSH_IPS" {
  value = "${azurerm_public_ip.node.*.ip_address}"
}

output "NODE_PRIVATE_IPS" {
  value = "${azurerm_network_interface.node.*.private_ip_address}"
}

output "LOAD_BALANCER_SSH_IPS" {
  value = "${azurerm_public_ip.controller.*.ip_address}"
}

output "LOAD_BALANCER_PUBLIC_IPS" {
  value = "${azurerm_public_ip.controller.*.ip_address}"
}
