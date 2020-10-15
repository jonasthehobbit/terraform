resource "azurerm_resource_group" "core_app_insights" {
  name     = "Application_Insights_rg"
  location = var.location
}

resource "azurerm_application_insights" "core_app_insights" {
  name                = "grp-core-appinsights"
  location            = var.location
  resource_group_name = azurerm_resource_group.core_app_insights.name
  application_type    = "web"
}

output "instrumentation_key" {
  value = azurerm_application_insights.core_app_insights.instrumentation_key
}

output "app_id" {
  value = azurerm_application_insights.core_app_insights.app_id
}