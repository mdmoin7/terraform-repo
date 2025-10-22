# main.tf : core infrastructure configuration file
# block to define a resource
# resource "<PROVIDER>_<TYPE>" "<NAME>"
# terraform init
# terraform plan
# terraform apply : if changes are there, it'll ask for confirmation
# if no changes nothing will be applied
# terraform destroy : to delete all resources created by terraform
# local variables block
locals {
  app_name       = "${var.application_name}-${local.env}-${random_string.suffix["web"].result}"
  env            = "dev"
  instance_count = 2
  length_count   = 8
}

output "app_name" {
  value = local.app_name
}

variable "instances" {
  default = ["web", "db", "cache"]
}
variable "server_instances" {
  type = map(any)
  default = {
    "web"   = 5
    "db"    = 3
    "cache" = 2
  }
}

resource "random_string" "suffix" {
  # count  = length(var.instances)
  for_each = var.server_instances
  length   = each.value
  upper    = var.instance_count % 2 != 0 ? false : true
}

