output "NAME" {
  value = "${local.name}"
}

output "ETCD_HOSTNAMES" {
  value = "${packet_device.etcd.*.hostname}"
}

output "ETCD_SSH_IPS" {
  value = "${packet_device.etcd.*.access_public_ipv4}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${packet_device.etcd.*.access_private_ipv4}"
}

output "CONTROLPLANE_HOSTNAMES" {
  value = "${packet_device.controlplane.*.hostname}"
}

output "CONTROLPLANE_SSH_IPS" {
  value = "${packet_device.controlplane.*.access_public_ipv4}"
}

output "CONTROLPLANE_PRIVATE_IPS" {
  value = "${packet_device.controlplane.*.access_private_ipv4}"
}

output "WORKER_SSH_IPS" {
  value = "${packet_device.worker.*.access_public_ipv4}"
}

output "WORKER_PRIVATE_IPS" {
  value = "${packet_device.worker.*.access_private_ipv4}"
}

output "WORKER_HOSTNAMES" {
  value = "${packet_device.worker.*.hostname}"
}
