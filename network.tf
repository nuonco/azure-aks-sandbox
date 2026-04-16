locals {
  service_cidr   = "10.2.1.0/24"
  dns_service_ip = "10.2.1.10"
}

// Data source to reference existing Virtual Network created by Bicep
data "azurerm_virtual_network" "existing" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

// Data source to reference existing subnet
data "azurerm_subnet" "existing" {
  name                 = local.private_subnet_name_list[0]
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

// Data source to reference pre-created ingress subnet for Application Gateway (AGIC)
data "azurerm_subnet" "ingress" {
  name                 = var.ingress_subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}
