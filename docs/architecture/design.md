# Architecture & design — Azure multi-environment IaC

**Status:** As-built (matches repository layout)  
**Companion:** [project-plan.md](./project-plan.md) · [overview.md](./overview.md) · [README.md](../../README.md)  
**Sibling repository (AWS):** [aws-multi-env-iac](https://github.com/btilki/aws-multi-env-iac)

---

## 1. Executive summary

This repository provisions **shared platform infrastructure** on Azure across **dev**, **staging**, and **prod**. A one-time **bootstrap** stack creates remote state storage. **Terragrunt** wraps Terraform modules and injects backend configuration from `live/root.hcl`. **Azure DevOps** runs formatting checks, bootstrap validation, **tfsec**, environment-scoped plans, manual applies, and weekly drift detection.

---

## 2. Goals and non-goals

### 2.1 Goals

- **Repeatable modules** for network, compute, and PostgreSQL.
- **Environment isolation** via separate Terragrunt folders and distinct `env.hcl` inputs (CIDR, VM SKU, instance count, tags).
- **Pipeline gates** before merge and before apply.
- **Operational hygiene**: drift pipeline, documented promotion and rollback paths.

### 2.2 Non-goals

- Application deployment and Kubernetes workloads — out of scope for this infrastructure repository.
- Multi-subscription landing zone or Azure Policy pack in this repo.
- Private Link / zero-trust networking for all services (documented as roadmap hardening).

---

## 3. Repository layout

```text
├── bootstrap/              # State RG, storage account, container
├── live/
│   ├── root.hcl            # Remote backend + generated provider
│   ├── dev|staging|prod/
│   │   ├── env.hcl         # Env-specific inputs
│   │   └── networking|compute|databases/terragrunt.hcl
├── modules/
│   ├── networking/
│   ├── compute/
│   └── databases/
├── .azuredevops/           # Pipeline templates
├── azure-pipelines*.yml
└── docs/
```

---

## 4. Module design

### 4.1 `modules/networking`

- Resource group, VNet, public/private subnets (CIDR lists from `env.hcl`).

### 4.2 `modules/compute`

- NSG with SSH and HTTPS egress rules; Linux VMSS with admin SSH key (no password auth).

### 4.3 `modules/databases`

- PostgreSQL Flexible Server, application database, firewall rule for private RFC1918 ranges.

**Dependencies:** `compute` and `databases` depend on `networking` outputs via Terragrunt `dependency` blocks. CI uses mock outputs and `TG_SKIP_DEP_OUTPUTS` for plan-only runs.

---

## 5. Identity and secrets

- Per-environment **Azure Resource Manager service connections** in Azure DevOps.
- Prefer **OIDC workload identity federation**; fallback to service principal secret (see `.azuredevops/terragrunt-job.yml`).
- Pipeline secrets: `TF_VAR_DB_PASSWORD`, `TF_VAR_ADMIN_SSH_PUBLIC_KEY` → mapped to `TF_VAR_db_password`, `TF_VAR_admin_ssh_public_key`.

Details: [governance-baseline.md](governance-baseline.md)

---

## 6. State and locking

- Backend: `azurerm` (blob per Terragrunt unit path).
- Bootstrap enables blob versioning; locking via Terraform Azure backend.
- Keep `live/root.hcl` aligned with `bootstrap/terraform.tfvars`.

Details: [state-strategy.md](state-strategy.md)

---

## 7. Environment differences

| Input | dev | staging | prod (example) |
|-------|-----|---------|----------------|
| VNet CIDR | 10.10.0.0/16 | 10.20.0.0/16 | 10.30.0.0/16 |
| VMSS instances | 1 | 2 | 3 |
| VM SKU | Standard_B2s | Standard_B2s | Standard_B4ms |

Source: `live/*/env.hcl`.

---

## 8. Related documents

- [environment-promotion.md](environment-promotion.md)
- [../onboarding/deployment.md](../onboarding/deployment.md)
- [../../SECURITY.md](../../SECURITY.md)
