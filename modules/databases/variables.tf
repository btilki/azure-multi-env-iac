variable "name_prefix" {
  description = "Name prefix for database resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where database resources are created."
  type        = string
}

variable "location" {
  description = "Azure location for database resources."
  type        = string
}

variable "db_name" {
  description = "Database name."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "PostgreSQL administrator username."
  type        = string
}

variable "db_password" {
  description = "PostgreSQL administrator password."
  type        = string
  sensitive   = true
}

variable "postgresql_version" {
  description = "PostgreSQL version."
  type        = string
  default     = "16"
}

variable "db_sku_name" {
  description = "Flexible server SKU."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "Storage size in MB."
  type        = number
  default     = 32768
}

variable "zone" {
  description = "Availability zone for the PostgreSQL server. Set to null for Azure-selected zone."
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "Common tags applied to resources."
  type        = map(string)
  default     = {}
}
