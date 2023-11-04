locals {
  workspace_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"

  vnet_name = terraform.workspace == "default" ? "${var.vnet_name}" : "${var.vnet_name}${local.workspace_suffix}"
  nsg_name = terraform.workspace == "default" ? "${var.nsg_name}" : "${var.nsg_name}${local.workspace_suffix}"
  subnet_name = terraform.workspace == "default" ? "${var.subnet_name}" : "${var.subnet_name}${local.workspace_suffix}"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${locals.nsg_name}"
  location            = azurerm_resource_group.rg-infra.location
  resource_group_name = azurerm_resource_group.rg-infra.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${locals.vnet_name}"
  location            = azurerm_resource_group.rg-infra.location
  resource_group_name = azurerm_resource_group.rg-infra.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${locals.subnet_name}"
  resource_group_name  = azurerm_resource_group.rg-infra.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsg_snet_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "ssh_inbound_myIP" {
  name                        = "SSHInboundMyIP"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "22"
  destination_port_range      = "22"
  source_address_prefix       = "123.145.167.189"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg-infra.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}