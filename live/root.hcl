# Shared Terragrunt root config for remote state and generated Azure provider settings.
locals {
  # Keep these values aligned with outputs from bootstrap/ (state_resource_group_name,
  # state_storage_account_name, state_container_name, and azure_location).
  project_name          = "multi-iac"
  azure_location        = "westeurope"
  state_resource_group  = "multi-iac-tfstate-rg"
  state_storage_account = "multiplatsa"
  state_container_name  = "tfstate"
}

remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = local.state_resource_group
    storage_account_name = local.state_storage_account
    container_name       = local.state_container_name
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
EOF
}
