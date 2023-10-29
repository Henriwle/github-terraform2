terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-backend-tfstate-hwl"
    storage_account_name = "sabetfsjph7asfaoh"
    container_name       = "tfstate"
    key                  = "web.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}