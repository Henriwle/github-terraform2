locals {
  workspace_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"

  sa_name    = terraform.workspace == "default" ? "${var.sa_name}" : "${var.sa_name}${local.workspace_suffix}"
  sc_name = terraform.workspace == "default" ? "${var.sc_name}" : "${var.sc_name}${local.workspace_suffix}"
  

}

resource "azurerm_storage_account" "sa" {
  name                     = "${locals.sa_name}${var.base_name}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.rg-infra.name
  location                 = azurerm_resource_group.rg-infra.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc" {
  name                  = "${locals.sc_name}${var.base_name}"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}