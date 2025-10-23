terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.49.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.7.2"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "e3954d8c-6194-4118-9e7e-cd12b3d1696a"
}
provider "azuread" {}
# get current user details
data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

# Resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-entra-app-demo"
  location = "East US"
}
# app registration
resource "azuread_application" "app" {
  display_name = "entra-app-demo"
  owners       = [data.azuread_client_config.current.object_id]
}
# service principal
resource "azuread_service_principal" "sp" {
  client_id                    = azuread_application.app.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}
# secret for the service principal
resource "azuread_application_password" "secret" {
  application_id    = azuread_application.app.id
  display_name      = "entra-app-demo-secret"
  end_date_relative = "8760h" # 1 year
}
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}
# key vault setup
resource "azurerm_key_vault" "kv" {
  name                       = "kv-entra-demo-${random_string.suffix.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  sku_name                   = "standard"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
}
#key vault access policy (for current user)
resource "azurerm_key_vault_access_policy" "me" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete", "Purge"
  ]
}
# store client secret in key vault
resource "azurerm_key_vault_secret" "client_secret" {
  name         = "entra-client-demo-secret"
  value        = azuread_application_password.secret.value
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_key_vault_access_policy.me]
}
# role assignment to allow SP to read secrets from key vault
resource "azurerm_role_assignment" "role" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}
# outputs
output "app_name" {
  value = azuread_application.app.display_name
}
output "client_id" {
  value = azuread_application.app.id
}
output "keyvault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}

# data "azurerm_key_vault_secret" "app_secret" {
#   name         = "entra-client-demo-secret"
#   key_vault_id = azurerm_key_vault.kv.id
# }

output "secret_value" {
  value     = azurerm_key_vault_secret.client_secret.value # data.azurerm_key_vault_secret.app_secret.value
  sensitive = true
}
