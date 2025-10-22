output "application_name" {
  value = var.application_name
}
output "environment" {
  value = var.environment
}
output "api_key" {
  value     = var.api_key
  sensitive = true
}
output "sku_settings" {
  value = var.sku_settings["kind"]
}
output "primary_region" {
  value = var.regions[0]
}
output "east_instance" {
  value = var.region_instance["us-east-1"]
}
output "tags" {
  value = var.unique_tags
}

locals {
  names       = ["john", "alice", "jane"]
  upper_names = [for n in local.names : upper(n)]
  prices = {
    "apple"  = 10
    "banana" = 5
    "grape"  = 15
  }
  discounted_prices = { for k, v in local.prices : k => v * 0.9 }
}

output "upper_names" {
  value = local.upper_names
}
output "discounted" {
  value = local.discounted_prices
}

locals {
  regions = ["us-east-1", "us-west-2"]
  zones   = ["a", "b"]
  combos = flatten([
    for r in local.regions : [
      for z in local.zones : "${r}${z}"
    ]
  ])
}
output "combos" {
  value = local.combos
}
