variable "project_name" {
  description = "Project prefix for resource naming."
  type        = string
  default     = "multi-iac"
}

variable "azure_location" {
  description = "Azure location for state resources."
  type        = string
  default     = "westeurope"
}

variable "environment_names" {
  description = "Environment names used for state prefixes."
  type        = list(string)
  default     = ["dev", "staging", "prod"]
}

variable "state_resource_group_name" {
  description = "Resource group that stores Terraform state resources."
  type        = string
}

variable "state_storage_account_name" {
  description = "Azure Storage Account name for Terraform state."
  type        = string
}

variable "state_container_name" {
  description = "Blob container used for Terraform state."
  type        = string
  default     = "tfstate"
}

variable "state_public_network_access_enabled" {
  description = "Whether public network access is enabled for the state storage account."
  type        = bool
  default     = true
}
