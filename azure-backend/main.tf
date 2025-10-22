resource "azurerm_resource_group" "main" {
  name     = "tfstate-rg"
  location = "East US"
}

resource "azurerm_storage_account" "main" {
  name                     = "tfstatebackend0010"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "Backend"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-analytics-workspace"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
