
module "sql" {
  source           = "./modules/sql"
  location         = var.location
  app_service_name = var.app_service_name
}
module "backup" {
  source           = "./modules/backup"
  backup_location  = var.backup_location
  app_service_name = var.app_service_name
}
module "insights" {
  source   = "./modules/insights"
  location = var.location
}
module "gateway" {
  source           = "./modules/gateway"
  location         = var.location
  app_service_name = var.app_service_name
  hostname         = azurerm_app_service.app_service.default_site_hostname
}
# Resource groups required ---------------------------------------------------
resource "azurerm_resource_group" "app_service_rg" {
  name     = "${var.app_service_name}-rg"
  location = var.location
}
# App Service configuration ---------------------------------------------------
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${var.app_service_name}-asp"
  location            = azurerm_resource_group.app_service_rg.location
  resource_group_name = azurerm_resource_group.app_service_rg.name
  kind                = var.app_service_kind
  reserved            = false

  sku {
    tier = var.app_service_tier
    size = var.app_service_size
  }
}

resource "azurerm_app_service" "app_service" {
  depends_on          = [module.sql, module.backup, module.insights]
  name                = "${var.app_service_name}-appservice"
  location            = azurerm_resource_group.app_service_rg.location
  resource_group_name = azurerm_resource_group.app_service_rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY        = module.insights.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = "instrumnetationkey=${module.insights.instrumentation_key}"
  }
  site_config {
    always_on = true
    default_documents = [
      "Default.htm",
      "Default.html",
      "Default.asp",
      "index.htm",
      "index.html",
      "iisstart.htm",
      "default.aspx",
      "index.php",
      "hostingstart.html",
    ]
    dotnet_framework_version    = "v4.0"
    ftps_state                  = "AllAllowed"
    http2_enabled               = false
    scm_use_main_ip_restriction = true
    #ip_restriction = [] #used to reset IP restrictions
    ip_restriction {
      action                    = "Allow"
      ip_address                = null
      name                      = "beAppGateway"
      priority                  = 1
      virtual_network_subnet_id = module.gateway.be_subnet_id
    }
  }
  backup {
    name                = "${var.app_service_name}-appservice-bkp"
    enabled             = true
    storage_account_url = module.backup.sas_uri
    schedule {
      frequency_interval       = 3
      frequency_unit           = "Hour"
      keep_at_least_one_backup = true
      retention_period_in_days = 30
    }
  }
  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = module.sql.connection_string
  }
}
