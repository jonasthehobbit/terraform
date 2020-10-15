resource "azurerm_resource_group" "core_app_gateway" {
  name     = "${var.app_gateway_name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "core_app_gateway" {
  name                = "${var.app_gateway_name}-network"
  resource_group_name = azurerm_resource_group.core_app_gateway.name
  location            = azurerm_resource_group.core_app_gateway.location
  address_space       = ["${var.gateway_cidr_block.0}"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "${var.app_gateway_name}-frontend"
  resource_group_name  = azurerm_resource_group.core_app_gateway.name
  virtual_network_name = azurerm_virtual_network.core_app_gateway.name
  address_prefixes     = ["${cidrsubnet(var.gateway_cidr_block.0, 8, 1)}"]
}

resource "azurerm_subnet" "backend" {
  name                 = "${var.app_gateway_name}-backend"
  resource_group_name  = azurerm_resource_group.core_app_gateway.name
  virtual_network_name = azurerm_virtual_network.core_app_gateway.name
  address_prefixes     = ["${cidrsubnet(var.gateway_cidr_block.0, 8, 2)}"]
  service_endpoints = [
    "Microsoft.Web",
  ]
}

resource "azurerm_public_ip" "core_app_gateway" {
  name                = "${var.app_gateway_name}-pip"
  resource_group_name = azurerm_resource_group.core_app_gateway.name
  location            = azurerm_resource_group.core_app_gateway.location
  allocation_method   = "Dynamic"
}

locals {
  backend_address_pool_name      = "${var.app_service_name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.core_app_gateway.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.core_app_gateway.name}-feip"
  http_setting_name              = "${var.app_service_name}-be-htst"
  listener_name                  = "${var.app_service_name}-httplstn"
  request_routing_rule_name      = "${var.app_service_name}-rqrt"
  backend_http_probe             = "${var.app_service_name}-httpprobe"
}

resource "azurerm_application_gateway" "network" {
  name                = "${var.app_gateway_name}-appgateway"
  resource_group_name = azurerm_resource_group.core_app_gateway.name
  location            = azurerm_resource_group.core_app_gateway.location

  sku {
    name     = "WAF_Medium"
    tier     = "WAF"
    capacity = 2
  }
  waf_configuration {
    enabled          = "true"
    firewall_mode    = "Detection"
    rule_set_type    = "OWASP"
    rule_set_version = "3.0"
  }
  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.core_app_gateway.id
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = [var.hostname]
  }

  probe {
    interval                                  = 30
    minimum_servers                           = 0
    name                                      = local.backend_http_probe
    path                                      = "/"
    pick_host_name_from_backend_http_settings = true
    protocol                                  = "Http"
    timeout                                   = 30
    unhealthy_threshold                       = 3
  }
  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 120
    probe_name                          = local.backend_http_probe
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}
data "azurerm_public_ip" "output" {
  depends_on          = [azurerm_application_gateway.network]
  name                = azurerm_public_ip.core_app_gateway.name
  resource_group_name = azurerm_resource_group.core_app_gateway.name
}

