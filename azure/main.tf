locals {
  environment = terraform.workspace
  rg_name     = "rg0-${var.application_name}-${local.environment}"
}

resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.primary_location
}

resource "azurerm_storage_account" "main" {
  name                     = "tfstor${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = local.environment
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
