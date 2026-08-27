# Incident response

Incident response procedures for the **Azure Multi-Environment IaC Platform**. Adapt severity thresholds and escalation paths to your organization's on-call model.

These procedures assume a lab or non-production deployment. The platform is **not production-ready** as shipped ([SECURITY.md](../../SECURITY.md)).

---

## Severity levels

| Level | Example | Response |
|-------|---------|----------|
| **SEV1** | Wrong destroy scope; prod outage | Stop applies; assess blast radius; rollback via Git + apply |
| **SEV2** | Drift accumulating; failed scheduled drift | Investigate within 1 hour; open fix PR |
| **SEV3** | CI fmt/tfsec failure on main | Fix before next promotion |

---

## First 15 minutes

1. **Confirm impact** — Azure Portal resource groups, pipeline last run, affected environment.
2. **Check recent changes** — last merge to `main`, last IaC Apply, manual portal edits.
3. **Review drift output** — IaC Drift pipeline logs per environment.
4. **State health** — can plan succeed? See [../runbooks/state-operations.md](../runbooks/state-operations.md).
5. **Secrets** — accidental rotation? verify ADO variables still set.

---

## Rollback options

| Layer | Action |
|-------|--------|
| Infrastructure code | Revert Git commit on `main`; run IaC Apply for affected env |
| Terraform state | Break-glass blob version restore — [state-operations.md](../runbooks/state-operations.md) |
| Azure resources | Prefer forward fix via IaC; avoid manual portal edits |

Document last-known-good commit SHA.

---

## Communication template

```text
Subject: [SEV<n>] Azure IaC Platform — <short summary>

Impact: <env / subscription / service>
Start: <UTC time>
Status: Investigating | Mitigated | Resolved
Actions: <bullet list>
Next update: <time>
```

---

## Escalation

- Platform owner: see [CODEOWNERS](../../CODEOWNERS)
- Security issues: [SECURITY.md](../../SECURITY.md) — private report, not public issues with exploit details

---

## Post-incident

- [ ] Timeline and root cause
- [ ] Update [../runbooks/troubleshooting.md](../runbooks/troubleshooting.md) if new symptom
- [ ] Entry in [CHANGELOG.md](../../CHANGELOG.md) if repo/process change
