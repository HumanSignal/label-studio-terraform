#!/usr/bin/env bash
set -euo pipefail ${DEBUG:+-x}

# Locate the root directory
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export VAR_FILE="${1}"

# Run common.sh script for variable declaration and validation
# shellcheck source=/dev/null
source "${ROOT}/scripts/common.sh"

# Make plan : this command will validate the terraform code
cd "${ROOT}"/env

# Terraform console will run console for debug.
# shellcheck disable=SC2086
terraform console ${TF_PARAMS:-}
