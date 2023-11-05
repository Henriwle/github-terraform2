locals {
  workspace_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"

  rg_name    = terraform.workspace == "default" ? "${var.rg_name}" : "${var.rg_name}-${local.workspace_suffix}"
  sa_name    = terraform.workspace == "default" ? "${var.sa_name}" : "${var.sa_name}${local.workspace_suffix}"
  kv_name    = terraform.workspace == "default" ? "${var.kv_name}" : "${var.kv_name}${local.workspace_suffix}"
  sa_accesskey_name = terraform.workspace == "default" ? "${var.sa_accesskey_name}" : "${var.sa_accesskey_name}${local.workspace_suffix}"
  sc_name = terraform.workspace == "default" ? "${var.sc_name}" : "${var.sc_name}${local.workspace_suffix}"
  vnet_name = terraform.workspace == "default" ? "${var.vnet_name}" : "${var.vnet_name}${local.workspace_suffix}"
  nsg_name = terraform.workspace == "default" ? "${var.nsg_name}" : "${var.nsg_name}${local.workspace_suffix}"
  subnet_name = terraform.workspace == "default" ? "${var.subnet_name}" : "${var.subnet_name}${local.workspace_suffix}"
  vm_nic_name = terraform.workspace == "default" ? "${var.vm_nic_name}" : "${var.vm_nic_name}${local.workspace_suffix}"
  vm_name = terraform.workspace == "default" ? "${var.vm_name}" : "${var.vm_name}${local.workspace_suffix}"
  pip_name = terraform.workspace == "default" ? "${var.pip_name}" : "${var.pip_name}${local.workspace_suffix}"
  vm_username = terraform.workspace == "default" ? "${var.vm_username}" : "${var.vm_username}${local.workspace_suffix}"

}
# Resource Group for all resources
resource "azurerm_resource_group" "rg-infra" {
  name     = "${local.rg_name}-${var.base_name}"
  location = var.location
}

resource "random_string" "random_string" {
  length  = 8
  special = false
  upper   = false
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!%&*()-_=+[]{}<>:?"
}

output "vm_password" {
  value     = azurerm_key_vault_secret.vm_password.value
  sensitive = true
}
#!!