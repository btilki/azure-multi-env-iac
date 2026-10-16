# Documentation

Index for the **Azure multi-environment IaC platform**. The project story is in the [root README](../README.md). This folder is the operator and architecture set.

**Production-pilot** baseline — see [SECURITY.md](../SECURITY.md) and [architecture/roadmap.md](architecture/roadmap.md).

## Start here

| Order | Document | Why |
|-------|----------|-----|
| 1 | [../README.md](../README.md) | What this repo is, what it is not, quick start |
| 2 | [architecture/overview.md](architecture/overview.md) | Topology, pipelines, figures |
| 3 | [onboarding/deployment.md](onboarding/deployment.md) | Identifiers, Azure DevOps, first apply |
| 4 | [SECURITY.md](../SECURITY.md) | As-built vs hardening target |
| 5 | [architecture/roadmap.md](architecture/roadmap.md) | What is still missing before real prod |

## Index

| Area | Path | Description |
|------|------|-------------|
| Architecture | [architecture/](architecture/) | Overview, design, state, governance, promotion, roadmap |
| Onboarding | [onboarding/](onboarding/) | Prerequisites, deployment phases, full runbook |
| Runbooks | [runbooks/](runbooks/) | CI/Terraform, state ops, troubleshooting |
| Diagrams | [diagrams/](diagrams/) | Mermaid figures (change flow, Terragrunt/state, Azure topology) |
| Incident response | [incident-response/](incident-response/) | Severity, rollback, escalation |
| Contributing | [../CONTRIBUTING.md](../CONTRIBUTING.md) | Local validate, TFLint, PR expectations |

**Root:** [README.md](../README.md) · [SECURITY.md](../SECURITY.md) · [CHANGELOG.md](../CHANGELOG.md) · [Makefile](../Makefile)
