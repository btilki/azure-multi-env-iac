# Changelog

All notable changes to this platform repository (IaC, CI, documentation) are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Explicit **not production-ready** status in README, SECURITY, architecture, and onboarding docs

### Changed

- Bootstrap `state_prefixes` output now lists per-stack blob keys (`{env}/{stack}/terraform.tfstate`) matching `live/root.hcl`
- Database SKU/storage and SSH CIDR live in `live/*/env.hcl` instead of stack-level Terragrunt overrides
- Makefile: staging/prod apply and destroy targets; `make validate` runs fmt checks and validates all environments
- CI Terragrunt validate covers `dev`, `staging`, and `prod`
- Pipeline run names, CODEOWNERS, and docs aligned with the as-built layout (NSG in compute, runbook apply phase)

## [1.0.0] - 2026-05

### Added

- Bootstrap stack for Azure remote state (resource group, storage account, private container)
- Terragrunt live stacks for dev, staging, and prod (networking, compute, databases)
- Reusable Terraform modules for network, VMSS, and PostgreSQL Flexible Server
- Azure DevOps pipelines: CI (validate, tfsec, plan all envs), manual apply, weekly drift
- Documentation: architecture, onboarding, runbooks, incident response, diagrams
- Root governance: `SECURITY.md`, `Makefile`, `CODEOWNERS`, `.editorconfig`, `.pre-commit-config.yaml`
- Architecture article: `docs/architecture/medium-article.md`
