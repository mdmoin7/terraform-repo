terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.49.0"
    }
  }
}


resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = "e3954d8c-6194-4118-9e7e-cd12b3d1696a"

}
# get current user details
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = var.kv_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

#create a secret in key vault
resource "azurerm_key_vault_secret" "example" {
  name         = "db-password"
  value        = var.db_password
  key_vault_id = azurerm_key_vault.kv.id
}
