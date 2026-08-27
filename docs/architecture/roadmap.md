# Roadmap

Planned improvements beyond the current as-built baseline. Items are prioritized in the platform engineering backlog; timelines depend on change windows and dependency work.

**This platform is not production-ready** until the security hardening items below are complete. The `prod` stack name does not mean the workload is safe for production traffic or data.

---

## Security hardening

| Item | Current | Target |
|------|---------|--------|
| SSH access | NSG allows configurable CIDR via `allowed_ssh_cidr` in `live/*/env.hcl` (default open) | Per-env bastion / Azure Bastion; restrict `allowed_ssh_cidr` |
| PostgreSQL | Public access enabled in module | Private endpoint + VNet integration; disable public access in prod |
| State storage | Public network access configurable in bootstrap | Private endpoint + network rules; RBAC-only access |
| CI supply chain | tfsec via remote install script | Pinned version, container job, or official task |

---

## Platform engineering

- Single source of truth for state backend names (generate `root.hcl` from bootstrap outputs or use Terragrunt `read_terragrunt_config`).
- Require `TF_VAR_db_password` in all environments (enforced in Terragrunt inputs).
- Azure Policy / Defender for Cloud integration in CI.
- Optional: Key Vault references for secrets instead of pipeline variables only.

---

## Observability & operations

- Azure Monitor alerts on VMSS, PostgreSQL, storage account availability.
- Runbook automation for common drift categories.
- Integration with Azure DevOps deployment gates based on plan summary.

---

## Multi-cloud parity

Align documentation and pipeline patterns with the AWS sibling repository:

[aws-multi-env-iac](https://github.com/btilki/aws-multi-env-iac)
