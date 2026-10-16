# Changelog

All notable changes to this platform repository (IaC, CI, documentation) are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.1.1] - 2026-10-16

### Changed

- Replaced the keyboard-drawn architecture PNG with three Mermaid figures (change flow, Terragrunt/state, Azure topology) in `docs/diagrams/` and the docs that used the PNG
- Added TFLint (AzureRM ruleset) and pinned tfsec in CI; module `versions.tf`; CONTRIBUTING and PR template
- Expanded `docs/README.md` with a start-here reading order

## [1.1.0] - 2026-10-15

### Changed

- Positioned the repository as a production-pilot baseline (not production-ready)
- Linked only the AWS sibling platform (`aws-multi-env-iac`); removed playbook homepage and AKS-ready wording from GitHub About
- Aligned architecture docs with as-built modules (no NAT/route tables in networking; NSG on compute; public PostgreSQL)
- Unified live and module provider lock files on AzureRM `4.69.0` (`~> 4.0`)
- Documented drift detection as manual by default; weekly schedule remains commented until Azure DevOps environments and service connections exist
- Kept local Terragrunt fmt as `hcl fmt --check` to match CI (Terragrunt `1.0.1`)
- Bootstrap `state_prefixes` match Terragrunt keys; DB SKU/storage and SSH CIDR live in `env.hcl`; Makefile and CI validate all environments

## [1.0.0] - 2026-05

### Added

- Bootstrap stack for Azure remote state (resource group, storage account, private container)
- Terragrunt live stacks for dev, staging, and prod (networking, compute, databases)
- Reusable Terraform modules for network, VMSS, and PostgreSQL Flexible Server
- Azure DevOps pipelines: CI (validate, tfsec, plan all envs), manual apply, drift detection
- Documentation: architecture, onboarding, runbooks, incident response, diagrams
- Root governance: `SECURITY.md`, `Makefile`, `CODEOWNERS`, `.editorconfig`, `.pre-commit-config.yaml`
- Architecture article: `docs/architecture/medium-article.md`
