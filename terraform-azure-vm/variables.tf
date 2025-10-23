# variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "Central US" # Changed to region with better quota availability

  validation {
    condition = contains([
      "East US", "East US 2", "Central US", "West US", "West US 2",
      "North Europe", "West Europe", "Southeast Asia", "East Asia"
    ], var.location)
    error_message = "Use a valid Azure region with available quota."
  }
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "linuxvm"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_source_address" {
  description = "Source IP address for SSH access (use your public IP for security)"
  type        = string
  default     = "*"
}

variable "os_disk_size" {
  description = "OS disk size in GB"
  type        = number
  default     = 32
}

variable "os_disk_type" {
  description = "OS disk type"
  type        = string
  default     = "Standard_LRS"
}

variable "public_ip_sku" {
  description = "SKU for the Public IP (Basic or Standard)"
  type        = string
  default     = "Standard" # Changed to Standard to avoid quota issues

  validation {
    condition     = contains(["Basic", "Standard"], var.public_ip_sku)
    error_message = "Public IP SKU must be either Basic or Standard."
  }
}

variable "public_ip_allocation" {
  description = "Allocation method for Public IP"
  type        = string
  default     = "Static" # Static is required for Standard SKU

  validation {
    condition     = contains(["Dynamic", "Static"], var.public_ip_allocation)
    error_message = "Allocation method must be either Dynamic or Static."
  }
}
