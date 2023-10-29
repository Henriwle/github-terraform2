terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.70.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rgwe" {
  name     = "rg-vnet-we"
  location = "West Europe"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-vnet-we"
  location            = azurerm_resource_group.rgwe.location
  resource_group_name = azurerm_resource_group.rgwe.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-01-we"
  location            = azurerm_resource_group.rgwe.location
  resource_group_name = azurerm_resource_group.rgwe.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "sn-01-we"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "sn-02-we"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.nsg.id
  }

  tags = {
    environment = "Production"
  }
}