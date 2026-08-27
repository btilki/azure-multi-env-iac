# Environment-specific values for the prod stack.

locals {
  environment = "prod"
  name_prefix = "multi-iac-prod"
  location    = "westeurope"
  tags = {
    Environment = "prod"
    Project     = "multi-iac"
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }

  vnet_cidr            = "10.30.0.0/16"
  public_subnet_cidrs  = ["10.30.1.0/24", "10.30.2.0/24"]
  private_subnet_cidrs = ["10.30.11.0/24", "10.30.12.0/24"]
  vm_size              = "Standard_B4ms"
  vm_instance_count    = 3
  admin_username       = "azureadmin"
  allowed_ssh_cidr     = "0.0.0.0/0"
  db_username          = "appadmin"
  db_sku_name          = "GP_Standard_D2ds_v4"
  storage_mb           = 131072
  db_zone              = null
}
