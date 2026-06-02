# Remote state strategy (Azure Storage)

This repository stores Terraform state in **Azure Blob Storage** using the `azurerm` backend. Terragrunt injects backend settings from `live/root.hcl`.

## Design

- **Bootstrap** (`bootstrap/`): provisions the state resource group, storage account, and private container (see `bootstrap/main.tf`).
- **Runtime** (`live/root.hcl`): must reference the same resource group, storage account, and container names as bootstrap outputs.
- **State keys**: one blob per Terragrunt unit, derived from the path under `live/` (for example `dev/networking/terraform.tfstate`, `staging/compute/terraform.tfstate`, `prod/databases/terraform.tfstate`).

Replace placeholder names in docs with your values from `bootstrap/terraform.tfvars` and `live/root.hcl`.

## Security controls

- Storage encrypted at rest (platform-managed keys in the bootstrap stack).
- Blob versioning enabled in bootstrap.
- Container access: private (`container_access_type = "private"`).
- **Public network access** on the state account is configurable via `state_public_network_access_enabled`. Restrict access and use private endpoints per organizational policy (see [roadmap.md](roadmap.md)).
- **Locking**: handled by the Terraform Azure backend (blob lease).

## Naming guidance

- **Resource group**: `<org>-<project>-tfstate-rg` (or your org standard).
- **Storage account**: globally unique, lowercase, no hyphens (for example `<org><project>sa`).
- **Container**: `tfstate` (or a single consistent name across all envs).
- Prefer **environment in the state key path**, not in the storage account name, unless you need hard subscription isolation.

## Operations

- Run bootstrap **once** per subscription/tenant where this state will live; then keep `live/root.hcl` in sync.
- Do not delete old blob versions in production without a written recovery process.
- For investigation, prefer read-only state export from the CLI, not hand-editing blobs:

```bash
cd live/dev
terragrunt run --all -- state pull
```

Use `live/staging` or `live/prod` instead of `live/dev` when you need another environment. Terragrunt version is pinned in `.azuredevops/variables-common.yml`.

## Related docs

- [../onboarding/runbook.md](../onboarding/runbook.md)
- [environment-promotion.md](environment-promotion.md)
- [../runbooks/state-operations.md](../runbooks/state-operations.md)
