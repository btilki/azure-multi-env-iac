# Troubleshooting

Symptom-based index. For pipeline-specific failures see [ci-terraform.md](ci-terraform.md).

---

## Terragrunt / Terraform

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `Error acquiring the state lock` | Stale lock or concurrent run | Wait; if safe, `terragrunt force-unlock <LOCK_ID>` after confirming no active apply |
| `storage account not found` | `live/root.hcl` out of sync with bootstrap | Align names with `bootstrap/terraform.tfvars` / outputs |
| `Missing required secret variable` in pipeline | ADO secrets not set | Add `TF_VAR_DB_PASSWORD`, `TF_VAR_ADMIN_SSH_PUBLIC_KEY` as secret variables |
| Plan fails on dependency outputs in CI | Expected when skipping deps | CI sets `TG_SKIP_DEP_OUTPUTS=true`; ensure mock outputs exist in `terragrunt.hcl` |
| Plan/apply fails on database password | `TF_VAR_db_password` unset | Export password or set ADO secret before plan/apply |

---

## Azure auth

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `AuthorizationFailed` | RBAC too narrow on SP/OIDC identity | Grant Contributor (or custom) on target RG/subscription; state blob data role on storage |
| OIDC works locally but not in pipeline | Wrong federated credential or connection | Re-create service connection with workload identity; verify tenant/subscription |
| `az account show` wrong sub | CLI context | `az account set --subscription ...` |

---

## Resources

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| VMSS create fails | Invalid SSH key format | Ensure full single-line public key in `TF_VAR_admin_ssh_public_key` |
| PostgreSQL create fails | Name not unique / quota | Change `name_prefix` or region; check subscription quotas |
| NSG / SSH unreachable | `allowed_ssh_cidr` too restrictive or too open | Set `allowed_ssh_cidr` in `live/<env>/env.hcl`; use Bastion for prod-shaped setups |

---

## Drift pipeline

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Drift job fails exit 2 | Real infrastructure drift | Review plan output; fix in Git or reconcile in Azure intentionally |
| Drift always clean but portal differs | Wrong subscription/connection | Verify service connection per env job |

---

## Escalation

See [../incident-response/README.md](../incident-response/README.md).
