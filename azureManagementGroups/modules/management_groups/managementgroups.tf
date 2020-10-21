resource "azurerm_management_group" "root" {
  for_each     = var.root_groups
  name         = each.key
  display_name = each.value.displayname

  #   subscription_ids = [
  #     data.azurerm_subscription.current.subscription_id,
  #   ]
  # other subscription IDs can go here
}
resource "azurerm_management_group" "child" {
  for_each     = var.root_groups
  name         = each.value
  display_name = each.value.key
  parent_management_group_id = each.key

  #   subscription_ids = [
  #     data.azurerm_subscription.current.subscription_id,
  #   ]
  # other subscription IDs can go here
}
