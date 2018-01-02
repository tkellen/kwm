output "NAME" {
  value = "${local.name}"
}

output "ETCD_HOSTNAMES" {
  value = "${digitalocean_droplet.etcd.*.name}"
}

output "ETCD_SSH_IPS" {
  value = "${digitalocean_droplet.etcd.*.ipv4_address}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${digitalocean_droplet.etcd.*.ipv4_address_private}"
}

output "CONTROLPLANE_HOSTNAMES" {
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

output "WORKER_HOSTNAMES" {
  value = "${digitalocean_droplet.worker.*.name}"
}
