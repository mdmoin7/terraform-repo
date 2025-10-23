output "keyvault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}
# az keyvault secret show --name db-password --vault-name kv-demo-0010
# terraform apply -auto-approve : to apply changes without confirmation prompt

output "public_ip" {
  value = azurerm_public_ip.main.ip_address
}
