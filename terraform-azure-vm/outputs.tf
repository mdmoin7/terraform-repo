# outputs.tf

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.main.ip_address
}

output "vm_fqdn" {
  description = "Fully qualified domain name of the VM"
  value       = "${azurerm_public_ip.main.domain_name_label}.${var.location}.cloudapp.azure.com"
}

output "website_url" {
  description = "URL to access the website"
  value       = "http://${azurerm_public_ip.main.ip_address}"
}

output "ssh_connection_command" {
  description = "SSH connection command"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

output "resource_ids" {
  description = "Map of important resource IDs"
  value = {
    vm_id        = azurerm_linux_virtual_machine.main.id
    vnet_id      = azurerm_virtual_network.main.id
    public_ip_id = azurerm_public_ip.main.id
    nic_id       = azurerm_network_interface.main.id
  }
  sensitive = true
}
