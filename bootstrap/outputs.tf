output "state_resource_group_name" {
  description = "Resource group used for remote state."
  value       = azurerm_resource_group.tfstate.name
}

output "state_storage_account_name" {
  description = "Storage account used for remote state."
  value       = azurerm_storage_account.tfstate.name
}

output "state_container_name" {
  description = "Blob container used for remote state."
  value       = azurerm_storage_container.tfstate.name
}

output "state_prefixes" {
  description = "Standardized state prefixes by environment."
  value       = [for env in var.environment_names : "${env}/terraform.tfstate"]
}
