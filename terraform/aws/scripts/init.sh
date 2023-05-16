#!/usr/bin/env bash
set -euo pipefail ${DEBUG:+-x}

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
export VAR_FILE="${1}"

# Run common.sh script for validation
# shellcheck source=/dev/null
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
               -input=false \
               "${ADDITIONAL_TF_PARAMS:=-input=false}" #workaround for SC2086

# Validate the Terraform resources.
terraform validate
