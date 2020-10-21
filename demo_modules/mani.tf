# block to define the provider or providers we're using
provider "azurerm" {
  features {}
}
# create all pre-reqs required for the virtual machine
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg"
  location = var.location
}
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-vnet"
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

#create virtual machines using a module and passing in a nested config variable
module "standard_vm" {
  vms      = var.virtual_machines
  source   = "./modules/standard_vm"
  location = azurerm_resource_group.main.location
  rg       = azurerm_resource_group.main.name
  snet     = azurerm_subnet.internal.id
}
