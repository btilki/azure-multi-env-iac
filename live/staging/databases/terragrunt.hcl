# Terragrunt unit for deploying database resources in staging.

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

dependency "networking" {
  config_path                             = "../networking"
  skip_outputs                            = get_env("TG_SKIP_DEP_OUTPUTS", "false") == "true"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    resource_group_name = "multi-iac-staging-rg"
    location            = "westeurope"
  }
}

terraform {
  source = "../../../modules/databases"
}

inputs = {
  name_prefix         = local.env.locals.name_prefix
  resource_group_name = dependency.networking.outputs.resource_group_name
  location            = dependency.networking.outputs.location
  db_name             = "appdb"
  db_username         = local.env.locals.db_username
  db_password         = get_env("TF_VAR_db_password")
  db_sku_name         = local.env.locals.db_sku_name
  storage_mb          = local.env.locals.storage_mb
  zone                = local.env.locals.db_zone
  tags                = local.env.locals.tags
}
