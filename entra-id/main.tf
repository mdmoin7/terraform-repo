terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.6.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

resource "azuread_user" "create" {
  user_principal_name = "demouser10@crimsonmoinhotmail.onmicrosoft.com"
  display_name        = "J. Doe"
  mail_nickname       = "jdoe"
  password            = "SecretP@sswd99!"
}

resource "azuread_group" "group" {
  display_name     = "My-Tf-Team"
  security_enabled = false
  owners           = [azuread_user.create.object_id]
  members          = [azuread_user.create.object_id]
}

data "azuread_client_config" "current" {}

resource "azuread_application" "app" {
  display_name = "sample-app"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "app_sp" {
  client_id                    = azuread_application.app.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

output "application_object_id" {
  value = azuread_application.app.object_id
}
