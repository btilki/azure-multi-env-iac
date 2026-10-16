# Contributing

How to change this **production-pilot** Azure IaC repo without breaking CI or state.

## Local checks (must match CI)

```bash
make fmt-check
make tg-fmt-check
make tflint
make validate
```

`make validate` runs Terraform fmt, Terragrunt HCL fmt, bootstrap validate, and Terragrunt validate for **dev, staging, and prod** (no remote backend). Secrets for that validate path are dummy values in the Makefile.

Optional: `pre-commit install` (see `.pre-commit-config.yaml`).

## Layout rules

- Environment inputs belong in `live/<env>/env.hcl`, not copied into each `terragrunt.hcl`.
- Keep `live/root.hcl` backend names aligned with `bootstrap/terraform.tfvars`.
- Do not commit `bootstrap/terraform.tfvars`, `*.tfstate`, or `.terragrunt-cache/`.
- Provider pin is AzureRM `~> 4.0` (see `bootstrap/main.tf`, `modules/*/versions.tf`, generated `versions.tf` from `live/root.hcl`).
- Bootstrap state storage uses `prevent_destroy`. Do not add that to live modules in this pilot (teardown must stay possible).

## Pull requests

- Open against `main`. **IaC CI** (`azure-pipelines.yml`) should run fmt, TFLint, validate, tfsec, and plan.
- Apply is **not** part of merge. Use `azure-pipelines-apply.yml` after merge, one environment at a time.
- If you change networking, compute, or databases modules, say which environments the plan will touch.

## Docs

Update the matching runbook or architecture page when behaviour changes. Figures are Mermaid under `docs/diagrams/`.
