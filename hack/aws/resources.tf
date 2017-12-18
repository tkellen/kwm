provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {
}

data "aws_ami" "ubuntu" {
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20171121.1"]
  }
}

locals {
  name = "aws"
  cidr = "10.100.0.0/16"
  etcd_count = 3
  controller_count = 1
  node_count = 3
  subnetCidrs = [
    "${cidrsubnet(local.cidr, 8, 0)}",
    "${cidrsubnet(local.cidr, 8, 1)}",
    "${cidrsubnet(local.cidr, 8, 2)}"
  ]
}

##
# Create a virtual network to hold our cluster.
#
resource "aws_vpc" "main" {
  cidr_block = "${local.cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "${local.name}"
  }
}

##
# Create one subnet for each provided cidr block.
#
resource "aws_subnet" "main" {
  count = "${length(local.subnetCidrs)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${element(local.subnetCidrs, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true
  tags {
    Name = "${local.name}-${count.index}"
  }
}

##
# Configure ACL to allow all inbound and outbound traffic.
#
resource "aws_network_acl" "main" {
  vpc_id = "${aws_vpc.main.id}"
  subnet_ids = ["${aws_subnet.main.*.id}"]
  ingress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  egress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  tags {
    Name = "${local.name}"
  }
}

##
# Create a gateway to the internet for our subnets.
#
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${local.name}"
  }
}

##
# Create a route table for subnets.
#
resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${local.name}"
  }
}

##
# Create an entry in each of our route tables that provides internet access
# via the gateway defined above.
#
resource "aws_route" "main" {
  route_table_id = "${aws_route_table.main.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

##
# Associate route tables with subnets.
#
resource "aws_route_table_association" "main" {
  count = "${length(local.subnetCidrs)}"
  subnet_id = "${element(aws_subnet.main.*.id, count.index)}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_security_group" "etcd" {
  name = "${local.name}-etcd"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${local.name}-etcd"
  }
}

resource "aws_security_group" "controller" {
  name = "${local.name}-controller"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${local.name}-controller"
  }
}

resource "aws_security_group" "node" {
  name = "${local.name}-node"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${local.name}-node"
  }
}

resource "aws_instance" "etcd" {
  count = "${local.etcd_count}"
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  key_name = "default"
  subnet_id = "${element(aws_subnet.main.*.id, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.etcd.id}"
  ]
  private_ip = "${cidrhost(element(aws_subnet.main.*.cidr_block, count.index), 5)}"
  tags {
    Name = "${local.name}-etcd-${count.index}"
  }
}

resource "aws_instance" "controller" {
  count = "${local.controller_count}"
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  key_name = "default"
  subnet_id = "${element(aws_subnet.main.*.id, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.controller.id}"
  ]
  private_ip = "${cidrhost(element(aws_subnet.main.*.cidr_block, count.index), 10)}"
  tags {
    Name = "${local.name}-controller-${count.index}"
  }
}

resource "aws_instance" "node" {
  count = "${local.node_count}"
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  key_name = "default"
  subnet_id = "${element(aws_subnet.main.*.id, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.node.id}"
  ]
  tags {
    Name = "${local.name}-node-${count.index}"
  }
  source_dest_check = false
}
