# Security

Security model for the **Azure Multi-Environment IaC Platform**.  
**Deploy:** [docs/onboarding/deployment.md](docs/onboarding/deployment.md) · **Architecture:** [docs/architecture/overview.md](docs/architecture/overview.md) · **Design:** [docs/architecture/design.md](docs/architecture/design.md)

---

## Principles

- **No secrets in Git** — passwords and SSH keys only in Azure DevOps secret variables or local shell exports.
- **Least privilege** — separate service connections per environment (`sc-azure-iac-dev`, `sc-azure-iac-staging`, `sc-azure-iac-prod`).
- **Gated infrastructure changes** — manual IaC Apply; CI validate + tfsec + plan before merge.
- **Environment isolation** — separate Terragrunt trees, VNet CIDRs, and RBAC scopes per stage.

---

## Identity and access

| Layer | Controls |
|-------|----------|
| Azure RBAC | Scoped Contributor (or custom) per env subscription/RG |
| Azure DevOps | Protected `main`, environment approvals on staging/prod |
| Pipeline auth | OIDC workload identity preferred; SP secret fallback in `terragrunt-job.yml` |
| State storage | Private container; versioning enabled; restrict public network access in production |

Prefer **OIDC federation** for service connections. Ensure deploy identity has blob data access for Terraform state when using RBAC on storage.

---

## Secrets

| Secret | Store |
|--------|--------|
| PostgreSQL admin password | `TF_VAR_DB_PASSWORD` (ADO secret) → `TF_VAR_db_password` |
| VMSS SSH public key | `TF_VAR_ADMIN_SSH_PUBLIC_KEY` (ADO secret) → `TF_VAR_admin_ssh_public_key` |
| Terraform state | Azure Storage (encrypted at rest) |

Never commit values in `*.tfvars` (except non-secret examples), `*.hcl`, or documentation.

---

## Runtime hardening (current baseline)

| Area | As-built | Production target |
|------|----------|-------------------|
| VM SSH | NSG rule; module default CIDR is broad | Restrict `allowed_ssh_cidr`; Azure Bastion |
| PostgreSQL | Public access enabled in module | Private endpoint; disable public access |
| State account | Public network access configurable | Private endpoint + network rules |

See [docs/architecture/roadmap.md](docs/architecture/roadmap.md).

---

## Supply chain

| Control | Tool / location |
|---------|-----------------|
| IaC scan | Azure DevOps: tfsec (Security stage) |
| Format / validate | `terraform fmt`, bootstrap validate, Terragrunt fmt |
| Provider pin | `~> 4.0` azurerm in `versions.tf` |
| Tool pin | Terraform/Terragrunt versions in `.azuredevops/variables-common.yml` |

---

## Reporting vulnerabilities

Report platform repo issues **privately** to the repository owner. Do not open public issues with exploit details for live environments.
