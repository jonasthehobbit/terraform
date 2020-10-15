output "app_name" {
  value = "${azurerm_app_service.app_service.name}"
}
output "app_gateway_uri" {
  value = module.gateway.domain_name_label
}
output "hostname" {
  value = "${azurerm_app_service.app_service.default_site_hostname}"
}
