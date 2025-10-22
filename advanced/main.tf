locals {
  regional_vms = [
    {
      region         = "westus",
      name           = "westus-vm-regionB"
      min_node_count = 4
    },
    {
      region         = "eastus",
      name           = "eastus0-vm-regionB"
      min_node_count = 8
    },
    {
      region         = "eastus",
      name           = "eastus1-vm-regionB"
      min_node_count = 4
    }
  ]
  region_vms_collection = {
    "westus0-vm" = { region = "westus", min_node_count = 2 },
    "westus1-vm" = { region = "westus", min_node_count = 4 }
  }
}

module "regions_collection" {
  source         = "./modules/regional-vms"
  for_each       = local.region_vms_collection
  region         = each.value.region
  name           = each.key
  min_node_count = each.value.min_node_count
}


module "random_name" {
  # local module : relative path
  # git repo
  # terraform registry
  source  = "./modules/random_string"
  length  = 10
  upper   = true
  special = true
}

module "random_id" {
  source = "./modules/random_string"
  length = 8
}

module "regionA" {
  source         = "./modules/regional-vms"
  region         = "eastus"
  name           = "regionA-vm"
  min_node_count = 2
}

module "regionB" {
  source         = "./modules/regional-vms"
  count          = length(local.regional_vms)
  region         = local.regional_vms[count.index].region
  name           = local.regional_vms[count.index].name
  min_node_count = local.regional_vms[count.index].min_node_count
}

