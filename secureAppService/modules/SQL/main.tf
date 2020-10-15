resource "azurerm_resource_group" "sql_rg" {
  name     = "${var.app_service_name}-rg"
  location = var.location
}
resource "azurerm_storage_account" "sql_storage" {
  name                     = "${replace(var.app_service_name, "-", "")}sqlstore"
  location                 = azurerm_resource_group.sql_rg.location
  resource_group_name      = azurerm_resource_group.sql_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
# SQL Service configuration ---------------------------------------------------
resource "azurerm_sql_server" "sql_instance" {
  name                         = "${var.app_service_name}-sqlserver"
  location                     = azurerm_resource_group.sql_rg.location
  resource_group_name          = azurerm_resource_group.sql_rg.name
  version                      = "12.0"
  administrator_login          = var.user_sql
  administrator_login_password = var.pass_sql
  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sql_storage.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sql_storage.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
  tags = {
    environment = "testing"
  }
}
resource "azurerm_sql_database" "sql_instance" {
  depends_on          = [azurerm_sql_server.sql_instance]
  name                = "${var.app_service_name}-sqldb"
  location            = azurerm_resource_group.sql_rg.location
  resource_group_name = azurerm_resource_group.sql_rg.name
  server_name         = azurerm_sql_server.sql_instance.name
  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sql_storage.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sql_storage.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
  tags = {
    environment = "testing"
  }
}
output "connection_string" {
    value = "Server=tcp:${azurerm_sql_server.sql_instance.fully_qualified_domain_name} Database=${azurerm_sql_database.sql_instance.name};User ID=${var.user_sql};Password=${var.pass_sql};Trusted_Connection=False;Encrypt=True;"
}