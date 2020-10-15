provider "azurerm" {
  version = "=2.0.0"
  features {}
}

module "resourceGroup" {
    source = "./modules/resourceGroup"
    config = local.config
    instances = local.instances
    default_tags = local.default_tags
}