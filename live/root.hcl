# Shared Terragrunt root config for remote state and generated Terraform settings.
# Keep backend identifiers aligned with bootstrap/terraform.tfvars (see terraform.tfvars.example).
locals {
  project_name          = "multi-iac"
  azure_location        = "westeurope"
  state_resource_group  = "multi-iac-tfstate-rg"
  state_storage_account = "replacewithuniquestorageacct"
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

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
EOF
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
