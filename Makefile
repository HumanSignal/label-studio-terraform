SHELL := /usr/bin/env bash
ROOT := ${CURDIR}
provider := ${}

.PHONY: help
help:
	@echo 'Usage:'
	@echo '    make init "provider=<REPLACEME>"	    Initialize and configure Terraform Backend.'
	@echo '    make plan "provider=<REPLACEME>"	    Plan all Terraform resources.'
	@echo '    make apply "provider=<REPLACEME>"    Create or update Terraform resources.'
	@echo '    make destroy "provider=<REPLACEME>"  Destroy all Terraform resources.'
	@echo '    make lint	                        Check syntax of all scripts.'
	@echo

# Before you run this command please export the required variables.
# Initialize the environment variables
.PHONY: init
init:
	bash $(ROOT)/terraform/$(provider)/scripts/init.sh

# Plan the Terraform resources
.PHONY: plan
plan:
	bash $(ROOT)/terraform/$(provider)/scripts/plan.sh

# Apply the Terraform resources
.PHONY: apply
apply:
	bash $(ROOT)/terraform/$(provider)/scripts/apply.sh

# Destroy the terraform resources
.PHONY: destroy
destroy:
	bash $(ROOT)/terraform/$(provider)/scripts/destroy.sh

.PHONY: lint
lint: check_shell check_terraform check_shebangs

# Shell check
.PHONY: check_shell
check_shell:
	source ${ROOT}/test/lint.sh && check_shell

# Terraform check
.PHONY: check_terraform
check_terraform:
	source ${ROOT}/test/lint.sh && check_terraform

# Shebangs check
.PHONY: check_shebangs
check_shebangs:
	source ${ROOT}/test/lint.sh && check_bash
