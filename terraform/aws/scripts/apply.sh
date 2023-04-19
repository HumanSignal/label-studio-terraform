#!/usr/bin/env bash
# shellcheck disable=SC2016
set -euo pipefail ${DEBUG:+-x}

# Locate the root directory
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export VAR_FILE="${1}"

# Run common.sh script for variable declaration and validation
# shellcheck source=/dev/null
source "${ROOT}/scripts/common.sh"

# Make apply : this command will apply the infrastructure changes
(
  cd "${ROOT}/env"
  # shellcheck disable=SC2086
  terraform apply -auto-approve ${TF_PARAMS:-}
)

# Get cluster outputs from the cluster.
GET_OUTPUTS='(cd "${ROOT}/env"; terraform output host)'
eval "${GET_OUTPUTS:-}"
