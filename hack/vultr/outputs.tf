output "NAME" {
  value = "${local.name}"
}

output "ETCD_HOSTNAMES" {
  value = "${vultr_instance.etcd.*.name}"
}

output "ETCD_SSH_IPS" {
  value = "${vultr_instance.etcd.*.ipv4_address}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${vultr_instance.etcd.*.ipv4_private_address}"
}

output "CONTROLPLANE_HOSTNAMES" {
  value = "${vultr_instance.controlplane.*.name}"
}

output "CONTROLPLANE_SSH_IPS" {
  value = "${vultr_instance.controlplane.*.ipv4_address}"
}

output "CONTROLPLANE_PRIVATE_IPS" {
  value = "${vultr_instance.controlplane.*.ipv4_private_address}"
}

output "WORKER_SSH_IPS" {
  value = "${vultr_instance.worker.*.ipv4_address}"
}

output "WORKER_PRIVATE_IPS" {
  value = "${vultr_instance.worker.*.ipv4_private_address}"
}

output "WORKER_HOSTNAMES" {
  value = "${vultr_instance.worker.*.name}"
}
