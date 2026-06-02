# State operations

Procedures for Azure Blob remote state used by Terragrunt.

**Strategy:** [../architecture/state-strategy.md](../architecture/state-strategy.md)

---

## Read state (safe)

```bash
cd live/dev/networking
terragrunt state list
terragrunt state pull > /tmp/dev-networking.tfstate.json
```

Do not edit pulled JSON and push back without a formal break-glass process.

---

## List blobs

```bash
az storage blob list \
  --account-name <storage_account_name> \
  --container-name tfstate \
  --auth-mode login \
  -o table
```

---

## Version recovery (break-glass)

Bootstrap enables **blob versioning**. To recover a previous state version:

1. Stop all applies to the affected stack.
2. Identify version in Azure Portal → Storage account → Containers → `tfstate` → blob versions.
3. Restore or copy version to active blob name matching Terragrunt key (for example `dev/networking/terraform.tfstate`).
4. Run `terragrunt plan` and verify expected diff before any apply.

Document every break-glass action in incident notes and [CHANGELOG.md](../../CHANGELOG.md) if process changes.

---

## Bootstrap changes

If moving state storage to a new account:

1. Plan migration window.
2. Update `bootstrap/` and `live/root.hcl`.
3. Migrate blobs or re-init stacks with `terraform state pull/push` under change control.

---

## Lock issues

If Terraform reports lock errors:

```bash
# Only after confirming no running pipeline or local apply
terragrunt force-unlock <LOCK_ID>
```

---

## Related

- [../incident-response/README.md](../incident-response/README.md)
- [troubleshooting.md](troubleshooting.md)
