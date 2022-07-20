SHELL := /usr/bin/env bash
ROOT := ${CURDIR}
provider := ${}
var_file := ${}

.PHONY: help
help:
	@echo 'Usage:'
	@echo '    make init    "provider=<REPLACE_ME>" "vars_file=<REPLACE_ME>" Initialize and configure Terraform Backend.'
	@echo '    make plan    "provider=<REPLACE_ME>" "vars_file=<REPLACE_ME>" Plan all Terraform resources.'
	@echo '    make apply   "provider=<REPLACE_ME>" "vars_file=<REPLACE_ME>" Create or update Terraform resources.'
	@echo '    make destroy "provider=<REPLACE_ME>" "vars_file=<REPLACE_ME>" Destroy all Terraform resources.'
	@echo '    make console "provider=<REPLACE_ME>" "vars_file=<REPLACE_ME>" Run terraform console to debug terraform resources.'
	@echo '    make lint	                                                 Check syntax of all scripts.'
	@echo '    make docs	                                                 Generate documentation for terraform modules.'
	@echo

# Before you run this command please export the required variables.
# Initialize the environment variables
.PHONY: init
init:
	bash $(ROOT)/terraform/$(provider)/scripts/init.sh "$(var_file)"

# Plan the Terraform resources
.PHONY: plan
plan:
	bash $(ROOT)/terraform/$(provider)/scripts/plan.sh "$(var_file)"

# Run terraform console for debug
.PHONY: console
console:
	bash $(ROOT)/terraform/$(provider)/scripts/console.sh "$(var_file)"

# Apply the Terraform resources
.PHONY: apply
apply:
	bash $(ROOT)/terraform/$(provider)/scripts/apply.sh "$(var_file)"

# Destroy the terraform resources
.PHONY: destroy
destroy:
	bash $(ROOT)/terraform/$(provider)/scripts/destroy.sh "$(var_file)"

.PHONY: lint
lint: check_shell check_terraform check_shebangs check_tflint check_tfsec

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

# TF Lint check
.PHONY: check_tflint
check_tflint:
	source ${ROOT}/test/lint.sh && check_tflint

# TF Sec check
.PHONY: check_tfsec
check_tfsec:
	source ${ROOT}/test/lint.sh && check_tfsec

# TF documentation
.PHONY: docs
docs:
	source ${ROOT}/terraform/common/scripts/docs.sh
