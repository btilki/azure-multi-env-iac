# Platform engineering shortcuts — Azure multi-environment IaC
# Requires: terraform, terragrunt, az (see docs/onboarding/README.md)

BOOTSTRAP_DIR := bootstrap
LIVE_DEV      := live/dev
LIVE_STAGING  := live/staging
LIVE_PROD     := live/prod
LIVE_ENVS     := $(LIVE_DEV) $(LIVE_STAGING) $(LIVE_PROD)
STACKS        := networking compute databases

.PHONY: help fmt fmt-check validate tg-validate tg-fmt-check bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy \
        tg-init-dev tg-plan-dev tg-apply-dev tg-destroy-dev \
        tg-init-staging tg-plan-staging tg-apply-staging tg-destroy-staging \
        tg-init-prod tg-plan-prod tg-apply-prod tg-destroy-prod

help:
	@echo "Targets:"
	@echo "  fmt                 - terraform fmt -recursive"
	@echo "  fmt-check           - terraform fmt -check -recursive"
	@echo "  validate            - fmt checks + bootstrap validate + Terragrunt validate (all envs, no backend)"
	@echo "  tg-validate         - terragrunt validate all stacks in live/dev, live/staging, live/prod (no backend)"
	@echo "  tg-fmt-check        - terragrunt hcl fmt --check"
	@echo "  bootstrap-init      - terraform init in bootstrap/"
	@echo "  bootstrap-plan      - terraform plan in bootstrap/"
	@echo "  bootstrap-apply     - terraform apply in bootstrap/"
	@echo "  bootstrap-destroy   - terraform destroy in bootstrap/"
	@echo "  tg-init-dev         - terragrunt run --all -- init in live/dev"
	@echo "  tg-plan-dev         - terragrunt run --all -- plan in live/dev"
	@echo "  tg-apply-dev        - terragrunt run --all -- apply in live/dev"
	@echo "  tg-destroy-dev      - terragrunt run --all -- destroy in live/dev"
	@echo "  tg-init-staging     - terragrunt run --all -- init in live/staging"
	@echo "  tg-plan-staging     - terragrunt run --all -- plan in live/staging"
	@echo "  tg-apply-staging    - terragrunt run --all -- apply in live/staging"
	@echo "  tg-destroy-staging  - terragrunt run --all -- destroy in live/staging"
	@echo "  tg-init-prod        - terragrunt run --all -- init in live/prod"
	@echo "  tg-plan-prod        - terragrunt run --all -- plan in live/prod"
	@echo "  tg-apply-prod       - terragrunt run --all -- apply in live/prod"
	@echo "  tg-destroy-prod     - terragrunt run --all -- destroy in live/prod"

fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -check -recursive

validate: fmt-check tg-fmt-check bootstrap-validate tg-validate

bootstrap-validate:
	terraform -chdir=$(BOOTSTRAP_DIR) init -input=false -backend=false
	terraform -chdir=$(BOOTSTRAP_DIR) validate

tg-validate:
	@set -euo pipefail; \
	export TG_SKIP_DEP_OUTPUTS=true; \
	export TF_VAR_db_password='local-validate-only'; \
	export TF_VAR_admin_ssh_public_key='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3FakeKeyForLocalValidateOnly user@host'; \
	for env in $(LIVE_ENVS); do \
	  for unit in $(STACKS); do \
	    echo "Validating $$(pwd)/$$env/$$unit..."; \
	    cd $$env/$$unit; \
	    terragrunt init -backend=false; \
	    terragrunt validate; \
	    cd - >/dev/null; \
	  done; \
	done

tg-fmt-check:
	terragrunt hcl fmt --check

bootstrap-init:
	terraform -chdir=$(BOOTSTRAP_DIR) init

bootstrap-plan:
	terraform -chdir=$(BOOTSTRAP_DIR) plan

bootstrap-apply:
	terraform -chdir=$(BOOTSTRAP_DIR) apply

bootstrap-destroy:
	terraform -chdir=$(BOOTSTRAP_DIR) destroy

tg-init-dev:
	cd $(LIVE_DEV) && terragrunt run --all -- init

tg-plan-dev:
	cd $(LIVE_DEV) && terragrunt run --all -- plan

tg-apply-dev:
	cd $(LIVE_DEV) && terragrunt run --all -- apply

tg-destroy-dev:
	cd $(LIVE_DEV) && terragrunt run --all -- destroy

tg-init-staging:
	cd $(LIVE_STAGING) && terragrunt run --all -- init

tg-plan-staging:
	cd $(LIVE_STAGING) && terragrunt run --all -- plan

tg-apply-staging:
	cd $(LIVE_STAGING) && terragrunt run --all -- apply

tg-destroy-staging:
	cd $(LIVE_STAGING) && terragrunt run --all -- destroy

tg-init-prod:
	cd $(LIVE_PROD) && terragrunt run --all -- init

tg-plan-prod:
	cd $(LIVE_PROD) && terragrunt run --all -- plan

tg-apply-prod:
	cd $(LIVE_PROD) && terragrunt run --all -- apply

tg-destroy-prod:
	cd $(LIVE_PROD) && terragrunt run --all -- destroy
