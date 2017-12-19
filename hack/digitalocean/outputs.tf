output "NAME" {
  value = "${local.name}"
}

output "ETCD_NAMES" {
  value = "${digitalocean_droplet.etcd.*.name}"
}

output "ETCD_SSH_IPS" {
  value = "${digitalocean_droplet.etcd.*.ipv4_address}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${digitalocean_droplet.etcd.*.ipv4_address_private}"
}

output "CONTROLPLANE_NAMES" {
  value = "${digitalocean_droplet.controlplane.*.name}"
}

output "CONTROLPLANE_SSH_IPS" {
  value = "${digitalocean_droplet.controlplane.*.ipv4_address}"
}

output "CONTROLPLANE_PRIVATE_IPS" {
  value = "${digitalocean_droplet.controlplane.*.ipv4_address_private}"
}

output "WORKER_SSH_IPS" {
  value = "${digitalocean_droplet.worker.*.ipv4_address}"
}

output "WORKER_PRIVATE_IPS" {
  value = "${digitalocean_droplet.worker.*.ipv4_address_private}"
}

output "WORKER_NAMES" {
  value = "${digitalocean_droplet.worker.*.name}"
}
