variable "name_prefix" {
  description = "Name prefix for compute resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where compute resources are created."
  type        = string
}

variable "location" {
  description = "Azure location for compute resources."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the VM scale set."
  type        = list(string)
}

variable "vm_size" {
  description = "VM SKU for the scale set."
  type        = string
  default     = "Standard_B2s"
}

variable "vm_instance_count" {
  description = "Desired VM instance count."
  type        = number
  default     = 1
}

variable "admin_username" {
  description = "Admin username for VM instances."
  type        = string
  default     = "azureadmin"
}

variable "admin_ssh_public_key" {
  description = "SSH public key for VM admin access."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH to VM instances."
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Common tags applied to resources."
  type        = map(string)
  default     = {}
}
