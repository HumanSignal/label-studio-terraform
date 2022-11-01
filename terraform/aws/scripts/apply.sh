#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Run common.sh script for variable declaration and validation
source "${ROOT}/scripts/common.sh"

# Make apply : this command will apply the infrastructure changes
(cd "${ROOT}/env"; terraform apply -no-color -auto-approve ${TF_PARAMS})

# Get cluster outputs from the cluster.
GET_OUTPUTS='(cd "${ROOT}/env"; terraform output cluster_endpoint)'
eval ${GET_OUTPUTS}
