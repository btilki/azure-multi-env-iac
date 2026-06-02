output "postgresql_server_id" {
  description = "PostgreSQL flexible server ID."
  value       = azurerm_postgresql_flexible_server.this.id
}

output "db_fqdn" {
  description = "PostgreSQL server FQDN."
  value       = azurerm_postgresql_flexible_server.this.fqdn
}
