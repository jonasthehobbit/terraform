output "be_subnet_id" {
  value = azurerm_subnet.backend.id
}
output "domain_name_label" {
  value = data.azurerm_public_ip.output.domain_name_label
}