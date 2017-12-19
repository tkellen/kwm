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

output "CONTROLPLANE_NAMES" {
  value = "${azurerm_virtual_machine.controlplane.*.name}"
}

output "CONTROLPLANE_SSH_IPS" {
  value = "${azurerm_public_ip.controlplane.*.ip_address}"
}

output "CONTROLPLANE_PRIVATE_IPS" {
  value = "${azurerm_network_interface.worker.*.private_ip_address}"
}

output "WORKER_NAMES" {
  value = "${azurerm_virtual_machine.worker.*.name}"
}

output "WORKER_SSH_IPS" {
  value = "${azurerm_public_ip.worker.*.ip_address}"
}

output "WORKER_PRIVATE_IPS" {
  value = "${azurerm_network_interface.worker.*.private_ip_address}"
}

output "LOAD_BALANCER_SSH_IPS" {
  value = "${azurerm_public_ip.controlplane.*.ip_address}"
}

output "LOAD_BALANCER_PUBLIC_IPS" {
  value = "${azurerm_public_ip.controlplane.*.ip_address}"
}
