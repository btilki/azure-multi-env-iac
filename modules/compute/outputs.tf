output "vmss_id" {
  description = "Virtual machine scale set ID."
  value       = azurerm_linux_virtual_machine_scale_set.this.id
}

output "vmss_name" {
  description = "Virtual machine scale set name."
  value       = azurerm_linux_virtual_machine_scale_set.this.name
}
