output "NAME" {
  value = "${local.name}"
}

output "CONTROLLER_NAMES" {
  value = "${aws_instance.controller.*.tags.Name}"
}

output "CONTROLLER_SSH_IPS" {
  value = "${aws_instance.controller.*.public_ip}"
}

output "CONTROLLER_PRIVATE_IPS" {
  value = "${aws_instance.controller.*.private_ip}"
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

output "NODE_SSH_IPS" {
  value = "${aws_instance.node.*.public_ip}"
}

output "NODE_PRIVATE_IPS" {
  value = "${aws_instance.node.*.private_ip}"
}

output "NODE_NAMES" {
  value = "${aws_instance.node.*.tags.Name}"
}

output "LOAD_BALANCER_SSH_IPS" {
  value = "${aws_instance.controller.*.public_ip}"
}

output "LOAD_BALANCER_PUBLIC_IPS" {
  value = "${aws_instance.controller.*.public_ip}"
}
