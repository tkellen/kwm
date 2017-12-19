provider "azurerm" { }

locals {
  name = "azure"
  location = "East US"
  cidr = "10.100.0.0/16"
  etcd_count = 1
  controlplane_count = 1
  worker_count = 2
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

resource "azurerm_public_ip" "controlplane" {
  count = "${local.controlplane_count}"
  name = "${local.name}-controlplane-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_public_ip" "worker" {
  count = "${local.worker_count}"
  name = "${local.name}-worker-${count.index}"
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

resource "azurerm_network_interface" "controlplane" {
  count = "${local.controlplane_count}"
  name = "${local.name}-controlplane-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"
  enable_ip_forwarding = true
  ip_configuration {
    name = "${local.name}"
    subnet_id = "${azurerm_subnet.main.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${element(azurerm_public_ip.controlplane.*.id, count.index)}"
  }
}

resource "azurerm_network_interface" "worker" {
  count = "${local.worker_count}"
  name = "${local.name}-worker-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"
  enable_ip_forwarding = true
  ip_configuration {
    name = "${local.name}"
    subnet_id = "${azurerm_subnet.main.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${element(azurerm_public_ip.worker.*.id, count.index)}"
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

resource "azurerm_virtual_machine" "controlplane" {
  count = "${local.controlplane_count}"
  name = "${local.name}-controlplane-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.controlplane.*.id, count.index)}"]
  vm_size = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_os_disk {
    name = "${local.name}-controlplane-${count.index}"
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
    computer_name = "${local.name}-controlplane-${count.index}"
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


resource "azurerm_virtual_machine" "worker" {
  count = "${local.worker_count}"
  name = "${local.name}-worker-${count.index}"
  location = "${local.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.worker.*.id, count.index)}"]
  vm_size = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_os_disk {
    name = "${local.name}-worker-${count.index}"
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
    computer_name = "${local.name}-worker-${count.index}"
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
