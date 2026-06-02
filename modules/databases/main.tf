resource "azurerm_postgresql_flexible_server" "this" {
  name                   = "${var.name_prefix}-pgsql"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgresql_version
  administrator_login    = var.db_username
  administrator_password = var.db_password
  sku_name               = var.db_sku_name
  storage_mb             = var.storage_mb
  zone                   = var.zone

  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = true

  lifecycle {
    # Azure PostgreSQL Flexible Server does not allow arbitrary in-place zone updates.
    # Ignore zone drift after creation to avoid apply failures on existing servers.
    ignore_changes = [zone]
  }

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_private_ranges" {
  name             = "allow-private-ranges"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = "10.0.0.0"
  end_ip_address   = "10.255.255.255"
}
