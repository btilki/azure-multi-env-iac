# Onboarding

Get from **zero** to deployed Azure infrastructure in **dev**, **staging**, and **prod**.

| Step | Document |
|------|----------|
| 1. Prerequisites & Azure DevOps setup | [deployment.md](deployment.md) |
| 2. Full command-by-command runbook | [runbook.md](runbook.md) |
| 3. Local shortcuts | [Makefile](../../Makefile) (`make help`) |

**Architecture:** [../architecture/overview.md](../architecture/overview.md)  
**Troubleshooting:** [../runbooks/troubleshooting.md](../runbooks/troubleshooting.md)

---

## Prerequisites (summary)

| Tool | Version |
|------|---------|
| Terraform | ≥ 1.6 |
| Terragrunt | ≥ 1.0 |
| Azure CLI | recent |
| Git | any recent |

```bash
terraform version && terragrunt --version && az version
az account show
```

Optional: `tfsec` (CI runs it automatically).

---

## Quick path

```bash
git clone https://github.com/btilki/azure-multi-env-iac.git
cd azure-multi-env-iac
cp bootstrap/terraform.tfvars.example bootstrap/terraform.tfvars
# Edit storage account name + align live/root.hcl
# Configure Azure DevOps pipelines, environments, service connections — see deployment.md
make bootstrap-init bootstrap-plan   # then bootstrap-apply when ready
export TF_VAR_db_password='...'
export TF_VAR_admin_ssh_public_key='...'
make tg-init-dev tg-plan-dev         # then tg-apply-dev
```

Estimated time: **60–120 minutes** including Azure DevOps setup and first apply.
