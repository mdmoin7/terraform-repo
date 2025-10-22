# Azure Provider source and version being used
# terraform init -upgrade : to upgrade provider versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.49.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
  backend "azurerm" {
    #use_azuread_auth = true # Can also be set via `ARM_USE_AZUREAD` environment variable.
    #tenant_id            = "03d39cd0-688d-4b4b-ab30-84ca20d952e2" # Can also be set via `ARM_TENANT_ID` environment variable.
    resource_group_name  = "rg-tfproj-dev"
    storage_account_name = "tfstor5vkzivrp5q"  # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"           # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "observability-dev" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

# Configure the Microsoft Azure Provider
# az account show : to get subscription id
provider "azurerm" {
  features {}
  subscription_id = "e3954d8c-6194-4118-9e7e-cd12b3d1696a"
}
