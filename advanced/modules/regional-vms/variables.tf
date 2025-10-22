variable "region" {
  description = "The region to deploy resources in"
  type        = string
}

variable "name" {
  type = string
}

variable "min_node_count" {
  type = number
  validation {
    condition     = var.min_node_count > 0
    error_message = "Min nodes should be 1 or more"
  }
}
