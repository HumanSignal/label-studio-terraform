#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail ${DEBUG:+-x}

# Locate the root directory
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VARS_FILE="${1}"

# Run common.sh script for variable declaration and validation
source "${ROOT}/scripts/common.sh"

# Make plan : this command will validate the terraform code
cd "${ROOT}"/env

# Terraform console will run console for debug.
terraform console "${TF_PARAMS:-}"
