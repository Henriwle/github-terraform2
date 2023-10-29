terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.70.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "fd-rg" {
  name     = var.rgname
  location = var.location
}


resource "azurerm_storage_account" "sa-demo" {
  name                     = var.saname
  resource_group_name      = azurerm_resource_group.fd-rg.name
  location                 = azurerm_resource_group.fd-rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}