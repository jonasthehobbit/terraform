resource "random_password" "password" {
  for_each         = var.vms
  length           = 10
  special          = true
  min_numeric      = 1
  min_upper        = 1
  override_special = "_%@"
}

resource "azurerm_network_interface" "vmnic" {
  for_each            = var.vms
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${each.key}-ipconfig"
    subnet_id                     = var.snet
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "standard" {
  for_each                      = var.vms
  name                          = "${each.key}-vm"
  location                      = var.location
  resource_group_name           = var.rg
  network_interface_ids         = [azurerm_network_interface.vmnic[each.key].id]
  vm_size                       = each.value.size
  delete_os_disk_on_termination = true
  storage_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
  storage_os_disk {
    name              = "${each.key}-vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${each.key}-vm1"
    admin_username = "testadmin"
    admin_password = random_password.password[each.key].result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
