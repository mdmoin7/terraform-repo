# terraform apply : input collected from terminal prompt
# terraform apply -var "application_name=myapp" : input passed via command line
locals {
  min_chars = 5
}
variable "application_name" {
  type = string
  validation {
    condition     = length(var.application_name) >= local.min_chars
    error_message = "Application name must be at least ${local.min_chars} characters long"
  }
}
variable "environment" {
  type = string
}
variable "api_key" {
  sensitive = true
  type      = string
}
variable "instance_count" {
  type = number
  validation {
    condition     = var.instance_count >= 5 && var.instance_count <= 10 && var.instance_count % 2 != 0
    error_message = "Instance count must be between 5 and 10"
  }
}
variable "instance_enabled" {
  type = bool
}
variable "sku_settings" {
  type = object({
    kind     = string
    tier     = string
    capacity = number
  })
}
variable "regions" {
  type = list(string)
}
variable "region_instance" {
  type = map(any)
  default = {
    "us-east-1" = 2
    "us-west-1" = 1
  }
}
variable "unique_tags" {
  type    = set(string)
  default = ["dev", "prod", "stage", "dev"]
}

variable "instance_type" {
  type = string
  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Instance type must be either t2.micro or t3.micro"
  }
}

variable "region" {
  type = string
  validation {
    condition     = can(regex("^us-(east|west)-[0-9]+$", var.region))
    error_message = "Region must match the pattern us-east-<number> or us-west-<number>"
  }
}

