#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Run common.sh script for validation
source "${ROOT}/scripts/common.sh"

# Terraform initialize should run on env folder.
cd "${ROOT}/env"

# Terraform initialize the backend bucket
terraform init -backend-config="bucket=${BUCKET_NAME}" \
               -backend-config="key=${TF_VAR_environment:-}-${TF_VAR_region:-}.tfstate" \
               -backend-config="region=${TF_VAR_region}" \
               -backend=true \
               -force-copy \
               -get=true \
               -input=false

# Validate the Terraform resources.
terraform validate

# Create workspace based on the environment, by doing this you don't overlap wih the resources in different environments.
terraform workspace new "${TF_VAR_environment:-}" || terraform workspace select "${TF_VAR_environment:-}"
