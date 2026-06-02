# Terragrunt unit for deploying compute resources in dev.

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
    resource_group_name = "multi-iac-dev-rg"
    location            = "westeurope"
    private_subnet_ids  = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock/providers/Microsoft.Network/virtualNetworks/mock/subnets/private-0"]
  }
}

terraform {
  source = "../../../modules/compute"
}

inputs = {
  name_prefix          = local.env.locals.name_prefix
  resource_group_name  = dependency.networking.outputs.resource_group_name
  location             = dependency.networking.outputs.location
  private_subnet_ids   = dependency.networking.outputs.private_subnet_ids
  vm_size              = local.env.locals.vm_size
  vm_instance_count    = local.env.locals.vm_instance_count
  admin_username       = local.env.locals.admin_username
  admin_ssh_public_key = get_env("TF_VAR_admin_ssh_public_key")
  tags                 = local.env.locals.tags
}
