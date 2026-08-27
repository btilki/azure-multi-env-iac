# Architecture overview

Multi-environment **Azure** infrastructure: Terraform modules, **Terragrunt** orchestration, **Azure DevOps** CI/CD, remote state in **Azure Blob Storage**.

**Status:** Reference platform — **not production-ready**. The `prod` environment is a third isolated stack, not a hardened production baseline. See [SECURITY.md](../../SECURITY.md) and [roadmap.md](roadmap.md).

**Full design:** [design.md](design.md) · **Plan:** [project-plan.md](project-plan.md)

![Platform overview](../diagrams/azure-multi-environment-iac-platform.png)

---

## Goals

- Infrastructure as code with reusable modules (`networking`, `compute`, `databases`)
- Three isolated environments: `dev`, `staging`, `prod` (separate VNets, SKUs, scale)
- Automated validate → security scan → plan on PR and `main`
- Gated manual apply per environment; scheduled drift detection
- Secrets only via Azure DevOps variables or local shell exports

---

## Azure topology (per environment)

| Layer | Resources |
|-------|-----------|
| State (shared) | Resource group, storage account, private blob container (`bootstrap/`) |
| Network | VNet, public/private subnets |
| Compute | Linux VM Scale Set (SSH key auth), NSG (SSH ingress, HTTPS egress) |
| Data | PostgreSQL Flexible Server + database + firewall rules |

Terragrunt units under `live/<env>/`: `networking` → `compute` / `databases`.

---

## CI/CD

| Pipeline | Trigger | Stages |
|----------|---------|--------|
| **IaC CI** (`azure-pipelines.yml`) | PR + push to `main` | Validate, Security (tfsec), Plan all envs |
| **IaC Apply** (`azure-pipelines-apply.yml`) | Manual | Validate, Security, Apply one env |
| **IaC Drift** (`azure-pipelines-drift.yml`) | Weekly Mon 03:00 UTC + manual | Validate, Security, Drift plan all envs |

| Concern | Owner |
|---------|--------|
| Bootstrap + live stacks | Azure DevOps → Terragrunt → Terraform |
| Approvals | Azure DevOps environments (`staging`, `prod`) |

Service connections (exact names): `sc-azure-iac-dev`, `sc-azure-iac-staging`, `sc-azure-iac-prod`.

---

## Related

- [state-strategy.md](state-strategy.md)
- [governance-baseline.md](governance-baseline.md)
- [environment-promotion.md](environment-promotion.md)
- [../onboarding/runbook.md](../onboarding/runbook.md)
