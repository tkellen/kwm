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

output "CONTROLPLANE_NAMES" {
  value = "${triton_machine.controlplane.*.name}"
}

output "CONTROLPLANE_SSH_IPS" {
  value = "${triton_machine.controlplane.*.primaryip}"
}

output "CONTROLPLANE_PRIVATE_IPS" {
  value = "${triton_machine.controlplane.*.ips.1}"
}

output "WORKER_SSH_IPS" {
  value = "${triton_machine.worker.*.primaryip}"
}

output "WORKER_PRIVATE_IPS" {
  value = "${triton_machine.worker.*.ips.1}"
}

output "WORKER_NAMES" {
  value = "${triton_machine.worker.*.name}"
}
