output "resource_group_name" {
  description = "Resource group for environment resources."
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "Azure location used for the environment."
  value       = azurerm_resource_group.this.location
}

output "virtual_network_name" {
  description = "Virtual network name."
  value       = azurerm_virtual_network.this.name
}

output "virtual_network_id" {
  description = "Virtual network ID."
  value       = azurerm_virtual_network.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = [for s in azurerm_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = [for s in azurerm_subnet.private : s.id]
}
