variable "name_prefix" {
  description = "Name prefix for networking resources."
  type        = string
}

variable "location" {
  description = "Azure location for networking resources."
  type        = string
}

variable "vnet_cidr" {
  description = "Virtual network CIDR block."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
}

variable "tags" {
  description = "Common tags applied to resources."
  type        = map(string)
  default     = {}
}
