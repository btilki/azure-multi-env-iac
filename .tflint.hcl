# TFLint: Terraform lint + AzureRM provider rules (see CI Validate stage).

plugin "azurerm" {
  enabled = true
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
  version = "0.32.0"
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

# Pilot stacks must remain destroyable (see onboarding teardown).
# State blobs are protected in bootstrap/main.tf with prevent_destroy.
rule "azurerm_resources_missing_prevent_destroy" {
  enabled = false
}
