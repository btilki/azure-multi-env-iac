# Deployment guide

Phased operator guide for the **Azure Multi-Environment IaC Platform**.  
**Detailed commands:** [runbook.md](runbook.md) · **Architecture:** [../architecture/overview.md](../architecture/overview.md) · **Security:** [../../SECURITY.md](../../SECURITY.md)

---

## Initial setup (configure identifiers)

| Location | Replace |
|----------|---------|
| `bootstrap/terraform.tfvars` | `state_storage_account_name` (globally unique), RG name, region |
| `live/root.hcl` | Same state RG, storage account, container as bootstrap |
| Azure DevOps service connections | Subscription scope per env; names `sc-azure-iac-*` |
| Azure DevOps secret variables | `TF_VAR_DB_PASSWORD`, `TF_VAR_ADMIN_SSH_PUBLIC_KEY` |
| [CODEOWNERS](../../CODEOWNERS) | `@YOUR_AZDO_USER` or GitHub username |

```bash
rg 'multiplatsa|multi-iac|your-' --glob '!docs/diagrams/*'
```

---

## Phases

| Phase | Focus | Reference |
|-------|--------|-----------|
| 0 | Prerequisites | [README](README.md) |
| 1 | Azure DevOps (envs, connections, pipelines) | [runbook.md §2](runbook.md#2-azure-devops-foundations) |
| 2 | Bootstrap remote state | [runbook.md §3](runbook.md#3-bootstrap-remote-state) |
| 3 | Align `live/root.hcl` | [runbook.md §4](runbook.md#4-align-terragrunt-root-config) |
| 4 | Local or pipeline apply (dev) | [runbook.md §5–6](runbook.md#5-export-runtime-secrets) |
| 5 | Promote staging → prod | [../architecture/environment-promotion.md](../architecture/environment-promotion.md) |
| 6 | Verification | [runbook.md §7](runbook.md#7-verify-azure-resources) |

---

## Terraform state

1. Run bootstrap once (`bootstrap/`).
2. Copy `terraform.tfvars.example` → `terraform.tfvars`.
3. Mirror identifiers in `live/root.hcl`.

```bash
make bootstrap-init bootstrap-plan bootstrap-apply
```

Details: [../architecture/state-strategy.md](../architecture/state-strategy.md)

---

## Azure DevOps variables

| Variable | Required for plan/apply |
|----------|-------------------------|
| `TF_VAR_DB_PASSWORD` | Yes (secret) |
| `TF_VAR_ADMIN_SSH_PUBLIC_KEY` | Yes (secret) |

Mapped at runtime to `TF_VAR_db_password` and `TF_VAR_admin_ssh_public_key` in `.azuredevops/terragrunt-job.yml`.

---

## Steady state

| Change type | Path |
|-------------|------|
| Infrastructure | PR → IaC CI → merge → manual IaC Apply per env |
| Drift | Weekly IaC Drift + investigation |

---

## Teardown

See [runbook.md — Teardown](runbook.md#8-teardown).

```bash
make tg-destroy-dev   # repeat for staging/prod, then bootstrap-destroy
```
