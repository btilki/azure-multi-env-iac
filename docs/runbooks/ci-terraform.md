# CI and Terraform runbook

Azure DevOps pipeline failures for **IaC CI**, **IaC Apply**, and **IaC Drift**.

---

## Pipeline map

| File | Purpose |
|------|---------|
| `azure-pipelines.yml` | PR/main: validate, tfsec, plan all envs |
| `azure-pipelines-apply.yml` | Manual apply; parameter `targetEnvironment` |
| `azure-pipelines-drift.yml` | Weekly + manual drift plan |
| `.azuredevops/terragrunt-job.yml` | Shared Terragrunt execution + auth |

---

## Validate stage failures

### `terraform fmt -check`

```bash
terraform fmt -recursive
terragrunt hcl fmt
git add -A && git commit -m "fmt"
```

### Bootstrap validate

```bash
terraform -chdir=bootstrap init -backend=false
terraform -chdir=bootstrap validate
```

### Terragrunt validate (dev stacks, no backend)

```bash
export TG_SKIP_DEP_OUTPUTS=true
export TF_VAR_db_password='local-validate-only'
export TF_VAR_admin_ssh_public_key='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3FakeKeyForLocalValidateOnly user@host'
for unit in networking compute databases; do
  cd "live/dev/${unit}"
  terragrunt init -backend=false
  terragrunt validate
  cd - >/dev/null
done
```

Or: `make tg-validate`

---

## Security stage (tfsec)

- Review findings in pipeline log.
- Fix module code or add documented exceptions per org policy.
- Run locally: install tfsec and `tfsec .` from repo root.

---

## Plan / apply job failures

### Missing secrets

Pipeline env in `terragrunt-job.yml` requires:

- `TF_VAR_DB_PASSWORD`
- `TF_VAR_ADMIN_SSH_PUBLIC_KEY`

Set at pipeline or variable group level; mark as secret.

### Auth to Azure

Job exports:

- `ARM_CLIENT_ID`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID`
- OIDC: `ARM_USE_OIDC=true`, `ARM_OIDC_TOKEN`
- Or SP secret: `ARM_CLIENT_SECRET`

Verify service connection **AddSpnToEnvironment** and subscription scope.

### Drift exit code 2

Apply template treats exit code **2** with `-detailed-exitcode` as success for drift jobs (drift detected). For apply jobs, investigate plan output.

---

## Version pins

`.azuredevops/variables-common.yml`:

- `terraformVersion`
- `terragruntVersion`

Bump only after local and CI validation across all three pipelines.

---

## Related

- [../architecture/governance-baseline.md](../architecture/governance-baseline.md)
- [troubleshooting.md](troubleshooting.md)
