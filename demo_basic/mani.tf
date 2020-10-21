# block to define the provider or providers we're using
provider "azurerm" {
  features {}
}

# resource for creating random strings that are considered secrets
resource "random_password" "password" {
  length = 10
  special = true
  override_special = "_%@"
}

# create all pre-reqs required for the virtual machine
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
}
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
resource "azurerm_subnet" "internal" {
  name                 = "${azurerm_virtual_network.main.name}-snet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# create virtual machines
resource "azurerm_network_interface" "firstnic" {
  name                = "${var.prefix}-nic1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${azurerm_virtual_network.main.name}-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "firstvm" {
  name                  = "${var.prefix}-vm1"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.firstnic.id]
  vm_size               = "Standard_A1_V2"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-vm1-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-vm1"
    admin_username = "testadmin"
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_network_interface" "secondnic" {
  name                = "${var.prefix}-nic2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${azurerm_virtual_network.main.name}-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "secondvm" {
  name                  = "${var.prefix}-vm2"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.secondnic.id]
  vm_size               = "Standard_A1_V2"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-vm2-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-vm2"
    admin_username = "testadmin"
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}