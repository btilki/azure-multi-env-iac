# Environment-specific values for the staging stack.

locals {
  environment = "staging"
  name_prefix = "multi-iac-staging"
  location    = "westeurope"
  tags = {
    Environment = "staging"
    Project     = "multi-iac"
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }

  vnet_cidr            = "10.20.0.0/16"
  public_subnet_cidrs  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnet_cidrs = ["10.20.11.0/24", "10.20.12.0/24"]
  vm_size              = "Standard_B2s"
  vm_instance_count    = 2
  admin_username       = "azureadmin"
  db_username          = "appadmin"
  db_zone              = null
}
