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

output "CONTROLLER_NAMES" {
  value = "${digitalocean_droplet.controller.*.name}"
}

output "CONTROLLER_SSH_IPS" {
  value = "${digitalocean_droplet.controller.*.ipv4_address}"
}

output "CONTROLLER_PRIVATE_IPS" {
  value = "${digitalocean_droplet.controller.*.ipv4_address_private}"
}

output "NODE_SSH_IPS" {
  value = "${digitalocean_droplet.node.*.ipv4_address}"
}

output "NODE_PRIVATE_IPS" {
  value = "${digitalocean_droplet.node.*.ipv4_address_private}"
}

output "NODE_NAMES" {
  value = "${digitalocean_droplet.node.*.name}"
}

output "LOAD_BALANCER_SSH_IPS" {
  value = "${digitalocean_droplet.controller.*.ipv4_address}"
}

output "LOAD_BALANCER_PUBLIC_IPS" {
  value = "${digitalocean_droplet.controller.*.ipv4_address}"
}
