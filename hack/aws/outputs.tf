output "NAME" {
  value = "${local.name}"
}

output "CONTROLPLANE_NAMES" {
  value = "${aws_instance.controlplane.*.tags.Name}"
}

output "CONTROLPLANE_SSH_IPS" {
  value = "${aws_instance.controlplane.*.public_ip}"
}

output "CONTROLPLANE_PRIVATE_IPS" {
  value = "${aws_instance.controlplane.*.private_ip}"
}

output "ETCD_NAMES" {
  value = "${aws_instance.etcd.*.tags.Name}"
}

output "ETCD_SSH_IPS" {
  value = "${aws_instance.etcd.*.public_ip}"
}

output "ETCD_PRIVATE_IPS" {
  value = "${aws_instance.etcd.*.private_ip}"
}

output "WORKER_SSH_IPS" {
  value = "${aws_instance.worker.*.public_ip}"
}

output "WORKER_PRIVATE_IPS" {
  value = "${aws_instance.worker.*.private_ip}"
}

output "WORKER_NAMES" {
  value = "${aws_instance.worker.*.tags.Name}"
}
