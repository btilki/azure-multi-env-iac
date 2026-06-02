# Operator runbook

Command-by-command procedures for bootstrap, Terragrunt stacks, verification, and teardown.

**Deployment phases:** [deployment.md](deployment.md) · **Architecture:** [../architecture/overview.md](../architecture/overview.md)

---

## 1. Azure subscription context

List subscriptions:

```bash
az account list -o table
```

Set target subscription:

```bash
az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"
```

If you need to switch tenant:

```bash
az logout
az login --tenant "<tenant-id>"
az account list -o table
```

Verify:

```bash
az account show
```

---

## 2. Azure DevOps foundations

### Environments

Create in **Pipelines → Environments**: `dev`, `staging`, `prod`.  
Add approvals/checks on `staging` and `prod`.

### Service connections

**Project settings → Service connections** — exact names:

- `sc-azure-iac-dev`
- `sc-azure-iac-staging`
- `sc-azure-iac-prod`

Recommended: Azure Resource Manager, **OIDC** when available, least-privilege scope per subscription/RG.  
Ensure identity can write state blobs (`Storage Blob Data Contributor` on state account if using RBAC).

### Pipelines

| Name | YAML |
|------|------|
| IaC CI | `azure-pipelines.yml` |
| IaC Apply | `azure-pipelines-apply.yml` |
| IaC Drift | `azure-pipelines-drift.yml` |

### Secret variables (mark as secret)

- `TF_VAR_DB_PASSWORD`
- `TF_VAR_ADMIN_SSH_PUBLIC_KEY`

---

## 3. Bootstrap remote state

```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars
# Set state_storage_account_name to a globally unique value
terraform init
terraform plan -out bootstrap.plan
terraform apply bootstrap.plan
```

Note outputs: resource group, storage account, container name.

---

## 4. Align Terragrunt root config

Edit `live/root.hcl`:

- `state_resource_group`
- `state_storage_account`
- `state_container_name`
- `azure_location`

Must match bootstrap values.

---

## 5. Export runtime secrets

Database password:

```bash
export TF_VAR_db_password='use-a-long-random-secret'
# Or generate:
export TF_VAR_db_password="${TF_VAR_db_password:-$(openssl rand -base64 32)}"
```

SSH public key:

```bash
export TF_VAR_admin_ssh_public_key="$(cat ~/.ssh/id_ed25519.pub)"
```

Verify:

```bash
test -n "$TF_VAR_db_password" && test -n "$TF_VAR_admin_ssh_public_key"
```

---

## 6. Deploy by environment

```bash
cd live/dev
terragrunt run --all -- init
terragrunt run --all -- plan
terragrunt run --all -- apply
```

Promotion order: `dev` → `staging` → `prod`.

Makefile shortcuts: `make tg-init-dev`, `make tg-plan-dev`, `make tg-apply-dev`.

---

## 7. Verify Azure resources

### State (bootstrap)

```bash
az group show --name multi-iac-tfstate-rg -o table
az storage account show --name <storage_account_name> --resource-group multi-iac-tfstate-rg -o table
```

### Per environment (example dev)

```bash
az resource list --resource-group multi-iac-dev-rg --output table
az vmss list --resource-group multi-iac-dev-rg -o table
az postgres flexible-server list --resource-group multi-iac-dev-rg -o table
az network vnet list --resource-group multi-iac-dev-rg -o table
```

### Terraform state

```bash
cd live/dev
terragrunt run --all -- state list
```

---

## 8. Teardown

```bash
export TF_VAR_db_password='same-secret-used-for-apply'
export TF_VAR_admin_ssh_public_key='...'

cd live/dev && terragrunt run --all -- destroy
cd ../staging && terragrunt run --all -- destroy
cd ../prod && terragrunt run --all -- destroy

cd ../../bootstrap && terraform destroy
```

---

## Control checklist (before first prod apply)

- [ ] Bootstrap complete; `live/root.hcl` matches
- [ ] Service connections and secrets configured
- [ ] IaC CI green on `main`
- [ ] IaC Apply succeeded in `dev` and `staging`
- [ ] Approvals configured for `prod`
