###############################################################################
# AWS outputs
###############################################################################

output "subnet_id" {
  description = "aws_subnet ID criado"
  value       = aws_subnet.subnet.id
}

output "security_group_id" {
  description = "ID do Security Group criado"
  value       = aws_security_group.security_group.id
}


###############################################################################
# AZURE outputs 
###############################################################################

output "storage_account_id" {
  description = "ID da Storage Account criada na Azure"
  value       = azurerm_storage_account.storage_account.id
}

output "sa_primary_access_key" {
  description = "Chave de acesso primária da Storage Account"
  value       = azurerm_storage_account.storage_account.primary_access_key
  sensitive   = true
}