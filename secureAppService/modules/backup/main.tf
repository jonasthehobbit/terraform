resource "azurerm_resource_group" "app_service_backup_rg" {
  name     = "${var.app_service_name}-bkprg"
  location = var.backup_location
}
resource "azurerm_storage_account" "app_backup_storage" {
  name                     = "${replace(var.app_service_name, "-", "")}appbkp"
  location                 = azurerm_resource_group.app_service_backup_rg.location
  resource_group_name      = azurerm_resource_group.app_service_backup_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "app_backup_storage_container" {
  name = "${replace(var.app_service_name, "-", "")}backups"
  storage_account_name = azurerm_storage_account.app_backup_storage.name
}

data "azurerm_storage_account_blob_container_sas" "container_sas" {
  connection_string = azurerm_storage_account.app_backup_storage.primary_connection_string
  container_name    = azurerm_storage_container.app_backup_storage_container.name
  https_only = true

  start  = "2020-08-11"
  expiry = "2022-08-11"

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}
output "sas_uri" {
    value = "https://${azurerm_storage_account.app_backup_storage.name}.blob.core.windows.net/${azurerm_storage_container.app_backup_storage_container.name}${data.azurerm_storage_account_blob_container_sas.container_sas.sas}"
}