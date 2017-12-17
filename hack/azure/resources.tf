# Setup:
# az login
# az account show
# export ARM_TENANT_ID=<tenantId from response above>
# export ARM_SUBSCRIPTION_ID=<id from response above>
# az ad sp create-for-rbac --role="Terraform" --scopes="/subscriptions/$ARM_SUBSCRIPTION_ID"
# ^ save this output for future runs
# export ARM_CLIENT_ID=<appId in response from "az ad sp....">
# export ARM_CLIENT_SECRET=<password in response from "az ad sp....">
#
# run terraform apply twice to populate the output variables.
provider "azurerm" { }

locals {
  name = "azure"
  location = "East US"
  cidr = "10.100.0.0/16"
  etcd_count = 1
  controller_count = 1
  node_count = 2
}

resource "azurerm_resource_group" "main" {
  name = "${local.name}"
  location = "${local.location}"
}

resource "azurerm_virtual_network" "main" {
  name  = "${local.name}"
  address_space = ["${local.cidr}"]
  location  = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "main" {
  name = "${local.name}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix = "${local.cidr}"
}

resource "azurerm_public_ip" "etcd" {
  count = "${local.etcd_count}"
  name = "${local.name}-etcd-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_public_ip" "controller" {
  count = "${local.controller_count}"
  name = "${local.name}-controller-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_public_ip" "node" {
  count = "${local.node_count}"
  name = "${local.name}-node-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_network_security_group" "main" {
  name = "${local.name}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  security_rule {
    name = "wide-open"
    priority = 1001
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "etcd" {
  count = "${local.etcd_count}"
  name = "${local.name}-etcd-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"
  enable_ip_forwarding = true
  ip_configuration {
    name = "${local.name}"
    subnet_id = "${azurerm_subnet.main.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${element(azurerm_public_ip.etcd.*.id, count.index)}"
  }
}

resource "azurerm_network_interface" "controller" {
  count = "${local.controller_count}"
  name = "${local.name}-controller-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"
  enable_ip_forwarding = true
  ip_configuration {
    name = "${local.name}"
    subnet_id = "${azurerm_subnet.main.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${element(azurerm_public_ip.controller.*.id, count.index)}"
  }
}

resource "azurerm_network_interface" "node" {
  count = "${local.node_count}"
  name = "${local.name}-node-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"
  enable_ip_forwarding = true
  ip_configuration {
    name = "${local.name}"
    subnet_id = "${azurerm_subnet.main.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${element(azurerm_public_ip.node.*.id, count.index)}"
  }
}

resource "azurerm_virtual_machine" "etcd" {
  count = "${local.etcd_count}"
  name = "${local.name}-etcd-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.etcd.*.id, count.index)}"]
  vm_size = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_os_disk {
    name = "${local.name}-etcd-${count.index}"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04.0-LTS"
    version = "latest"
  }
  os_profile {
    computer_name = "${local.name}-etcd-${count.index}"
    admin_username = "ubuntu"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }
}

resource "azurerm_virtual_machine" "controller" {
  count = "${local.controller_count}"
  name = "${local.name}-controller-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.controller.*.id, count.index)}"]
  vm_size = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_os_disk {
    name = "${local.name}-controller-${count.index}"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04.0-LTS"
    version = "latest"
  }
  os_profile {
    computer_name = "${local.name}-controller-${count.index}"
    admin_username = "ubuntu"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }
}


resource "azurerm_virtual_machine" "node" {
  count = "${local.node_count}"
  name = "${local.name}-node-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.node.*.id, count.index)}"]
  vm_size = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_os_disk {
    name = "${local.name}-node-${count.index}"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04.0-LTS"
    version = "latest"
  }
  os_profile {
    computer_name = "${local.name}-node-${count.index}"
    admin_username = "ubuntu"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }
}
