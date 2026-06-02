# Environment-specific values for the dev stack.

locals {
  environment = "dev"
  name_prefix = "multi-iac-dev"
  location    = "westeurope"
  tags = {
    Environment = "dev"
    Project     = "multi-iac"
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }

  vnet_cidr            = "10.10.0.0/16"
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.12.0/24"]
  vm_size              = "Standard_B2s"
  vm_instance_count    = 1
  admin_username       = "azureadmin"
  db_username          = "appadmin"
  db_zone              = null
}
