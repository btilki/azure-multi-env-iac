# Governance and security baseline

This document matches how the repo is wired today: **Azure** resources, **Terraform + Terragrunt**, and **Azure DevOps** pipelines under `azure-pipelines*.yml`.

**Not production-ready.** Pipeline gates and environment isolation are in place; runtime networking defaults are still lab-oriented. See [SECURITY.md](../../SECURITY.md) and [roadmap.md](roadmap.md) before treating `prod` as a production environment.

## Identity and access

- Use **separate Azure Resource Manager service connections** per environment (`sc-azure-iac-dev`, `sc-azure-iac-staging`, `sc-azure-iac-prod`). Pipeline templates reference these names directly.
- Grant **least privilege** on each subscription or resource group boundary you use for `dev`, `staging`, and `prod`.
- Prefer **workload identity federation (OIDC)** for service connections where your Azure DevOps org allows it, instead of long-lived secrets.
- Restrict **production** deploy permissions: protected `main` branch, pipeline approvals on the `prod` environment, and minimal principals that can run `azure-pipelines-apply.yml` against `prod`.

## Pipeline gates

- **Format + bootstrap validate + Terragrunt validate** — runs in **Validate** on `azure-pipelines.yml`, `azure-pipelines-apply.yml`, and `azure-pipelines-drift.yml` (`terraform fmt`, `terragrunt hcl fmt`, bootstrap validate, per-unit `terragrunt validate` in `live/dev`, `live/staging`, and `live/prod` with mock dependencies).
- **Security scan** — **Security** stage on the same three pipelines (`tfsec`).
- **Plan all environments** — `azure-pipelines.yml` only, after Security (`dev`, `staging`, `prod`).
- **Apply one environment** — `azure-pipelines-apply.yml` only, manual run with parameter `targetEnvironment`.
- **Drift detection** — `azure-pipelines-drift.yml`, weekly on `main` (`0 3 * * 1` UTC) plus manual runs.

- Treat **failed CI plan or validate** as a merge blocker for infrastructure changes.
- Keep **drift** scheduled so unintended changes surface without a PR.

## Version pinning

- Terraform: `1.6.6` in `.azuredevops/variables-common.yml` (raise deliberately and test all pipelines).
- Terragrunt: `1.0.1` in the same file (Terragrunt 1.x `run --` / `run --all` CLI).
- AzureRM provider: `~> 4.0` in `bootstrap/main.tf` and generated `versions.tf` from `live/root.hcl`.

## Required tags

Every resource should carry at least:

- `Project`
- `Environment`
- `ManagedBy`
- `Owner`

Values are set per environment in `live/*/env.hcl` (`tags` map) and passed into modules.

## Secret management

- Store sensitive values only in **Azure DevOps secret variables** or **variable groups**, for example:
  - `TF_VAR_DB_PASSWORD`
  - `TF_VAR_ADMIN_SSH_PUBLIC_KEY`
- The job template maps those to Terraform environment variables `TF_VAR_db_password` and `TF_VAR_admin_ssh_public_key` (see `.azuredevops/terragrunt-job.yml`).
- Never commit secrets in `*.tf`, `*.tfvars`, `*.hcl`, or docs.

## Related docs

- [../../README.md](../../README.md)
- [state-strategy.md](state-strategy.md)
- [environment-promotion.md](environment-promotion.md)
- [../../SECURITY.md](../../SECURITY.md)
