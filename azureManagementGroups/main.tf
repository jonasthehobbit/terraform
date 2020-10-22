provider "azurerm" {
  features {}
}

module "management_groups" {
  source = "./modules/management_groups"
  root_groups = local.groups
  children = 
}