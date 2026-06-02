# Platform engineering shortcuts — Azure multi-environment IaC
# Requires: terraform, terragrunt, az (see docs/onboarding/README.md)

BOOTSTRAP_DIR := bootstrap
LIVE_DEV      := live/dev
LIVE_STAGING  := live/staging
LIVE_PROD     := live/prod

.PHONY: help fmt validate tg-fmt-check bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy \
        tg-init-dev tg-plan-dev tg-apply-dev tg-destroy-dev \
        tg-init-staging tg-plan-staging tg-init-prod tg-plan-prod

help:
	@echo "Targets:"
	@echo "  fmt                 - terraform fmt -recursive"
	@echo "  validate            - bootstrap validate (no backend)"
	@echo "  tg-fmt-check        - terragrunt hcl fmt --check"
	@echo "  bootstrap-init      - terraform init in bootstrap/"
	@echo "  bootstrap-plan      - terraform plan in bootstrap/"
	@echo "  bootstrap-apply     - terraform apply in bootstrap/"
	@echo "  bootstrap-destroy   - terraform destroy in bootstrap/"
	@echo "  tg-init-dev         - terragrunt run --all -- init in live/dev"
	@echo "  tg-plan-dev         - terragrunt run --all -- plan in live/dev"
	@echo "  tg-apply-dev        - terragrunt run --all -- apply in live/dev"
	@echo "  tg-destroy-dev      - terragrunt run --all -- destroy in live/dev"
	@echo "  tg-plan-staging     - plan in live/staging"
	@echo "  tg-plan-prod        - plan in live/prod"

fmt:
	terraform fmt -recursive

validate:
	terraform -chdir=$(BOOTSTRAP_DIR) init -input=false -backend=false
	terraform -chdir=$(BOOTSTRAP_DIR) validate

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

tg-init-prod:
	cd $(LIVE_PROD) && terragrunt run --all -- init

tg-plan-prod:
	cd $(LIVE_PROD) && terragrunt run --all -- plan
