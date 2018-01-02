output "NAME" {
  value = "${local.name}"
}

output "ETCD_HOSTNAMES" {
  value = "${scaleway_server.etcd.*.name}"
}

output "ETCD_SSH_IPS" {
  value = "${scaleway_server.etcd.*.public_ip}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${scaleway_server.etcd.*.private_ip}"
}

output "CONTROLPLANE_HOSTNAMES" {
  value = "${scaleway_server.controlplane.*.name}"
}

output "CONTROLPLANE_SSH_IPS" {
  value = "${scaleway_server.controlplane.*.public_ip}"
}

output "CONTROLPLANE_PRIVATE_IPS" {
  value = "${scaleway_server.controlplane.*.private_ip}"
}

output "WORKER_SSH_IPS" {
  value = "${scaleway_server.worker.*.public_ip}"
}

output "WORKER_PRIVATE_IPS" {
  value = "${scaleway_server.worker.*.private_ip}"
}

output "WORKER_HOSTNAMES" {
  value = "${scaleway_server.worker.*.name}"
}
