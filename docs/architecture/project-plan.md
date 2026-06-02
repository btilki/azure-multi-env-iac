# Project plan

Phased delivery checklist for standing up this platform.  
**Runbook:** [../onboarding/runbook.md](../onboarding/runbook.md) · **Deployment:** [../onboarding/deployment.md](../onboarding/deployment.md)

---

## Phase 0 — Prerequisites

- [ ] Azure subscription(s) or resource groups for dev / staging / prod
- [ ] Azure DevOps project with permission to create pipelines and environments
- [ ] Tools installed locally: Terraform ≥ 1.6, Terragrunt ≥ 1.0, Azure CLI
- [ ] SSH key pair for VMSS admin access

---

## Phase 1 — Azure DevOps foundation

- [ ] Environments: `dev`, `staging`, `prod` (approvals on staging/prod)
- [ ] Service connections: `sc-azure-iac-dev`, `sc-azure-iac-staging`, `sc-azure-iac-prod` (OIDC preferred)
- [ ] Pipelines: IaC CI, IaC Apply, IaC Drift (YAML paths in repo root)
- [ ] Secret variables: `TF_VAR_DB_PASSWORD`, `TF_VAR_ADMIN_SSH_PUBLIC_KEY`

---

## Phase 2 — Bootstrap remote state

- [ ] Copy `bootstrap/terraform.tfvars.example` → `terraform.tfvars`
- [ ] Choose globally unique storage account name
- [ ] `terraform init && plan && apply` in `bootstrap/`
- [ ] Update `live/root.hcl` to match bootstrap outputs

---

## Phase 3 — First environment (dev)

- [ ] Export `TF_VAR_db_password` and `TF_VAR_admin_ssh_public_key`
- [ ] `terragrunt run --all -- init` in `live/dev`
- [ ] Plan and apply networking → compute → databases
- [ ] Verify resources in Azure Portal / CLI

---

## Phase 4 — CI green path

- [ ] Open PR; confirm IaC CI: fmt, validate, tfsec, plan (all envs)
- [ ] Merge to `main`
- [ ] Manual IaC Apply with `targetEnvironment = dev`

---

## Phase 5 — Promotion

- [ ] Apply staging (with approvals)
- [ ] Smoke checks
- [ ] Apply prod (change window + approvals)

---

## Phase 6 — Steady state

- [ ] Weekly drift pipeline enabled on `main`
- [ ] Document owners in [CODEOWNERS](../../CODEOWNERS)
- [ ] Review [roadmap.md](roadmap.md) for production hardening

---

## Success criteria

| Check | Command / location |
|-------|-------------------|
| State storage exists | `az storage account show` (bootstrap outputs) |
| Dev RG populated | `az resource list -g multi-iac-dev-rg` |
| CI passes | Azure DevOps IaC CI on `main` |
| No secrets in Git | `rg 'password\s*=' --glob '*.tfvars'` (only examples) |
