#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail ${DEBUG:+-x}

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Run common.sh script for variable declaration and validation
source "${ROOT}/scripts/common.sh"

# Make plan : this command will validate the terraform code
cd "${ROOT}"/env

# Terraform validate before the plan
terraform validate

# Terraform plan will create a plan file in your current repository. Verify the all the resource it create by using plan.
terraform plan -no-color -out=./plan.json "${TF_PARAMS:-}"
