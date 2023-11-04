locals {
  workspace_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"

  kv_name    = terraform.workspace == "default" ? "${var.kv_name}" : "${var.kv_name}${local.workspace_suffix}"
  sa_accesskey_name = terraform.workspace == "default" ? "${var.sa_accesskey_name}" : "${var.sa_accesskey_name}${local.workspace_suffix}"
  vm_name = terraform.workspace == "default" ? "${var.vm_name}" : "${var.vm_name}${local.workspace_suffix}"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "${locals.kv_name}${var.base_name}${random_string.random_string.result}"
  location                    = azurerm_resource_group.rg-infra.location
  resource_group_name         = azurerm_resource_group.rg-infra.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
    ]

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]

    storage_permissions = [
      "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
    ]
  }
}

resource "azurerm_key_vault_secret" "sa_accesskey" {
  name         = "${locals.sa_accesskey_name}${azurerm_storage_account.sa.name}"
  value        = azurerm_storage_account.sa.primary_access_key
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_storage_account.sa
  ]
}

resource "azurerm_key_vault_secret" "vm_password" {
  name         = "${locals.vm_name}${random_string.random_string.result}"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    random_password.password
  ]
}