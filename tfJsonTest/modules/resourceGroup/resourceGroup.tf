resource "azurerm_resource_group" "example" {
  for_each = var.instances
  name     = "rg-${var.config.projectname}-${each.key}"
  location = each.value.location
  tags = var.default_tags
  lifecycle {
    ignore_changes = [tags]
  }
}
