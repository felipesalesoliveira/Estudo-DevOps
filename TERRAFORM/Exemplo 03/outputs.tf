output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.subnet.id
}

output "security_group_id" {
  description = "The ID of the network security group"
  value       = azurerm_network_security_group.network_security_group.id

}