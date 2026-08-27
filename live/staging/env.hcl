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
  allowed_ssh_cidr     = "0.0.0.0/0"
  db_username          = "appadmin"
  db_sku_name          = "B_Standard_B2s"
  storage_mb           = 65536
  db_zone              = null
}
