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
  }
}

# Configure the Microsoft Azure Provider
# az account show : to get subscription id
provider "azurerm" {
  features {}
  subscription_id = "e3954d8c-6194-4118-9e7e-cd12b3d1696a"
}
