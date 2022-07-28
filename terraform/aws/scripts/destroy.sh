#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

# Locate the root directory
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Run common.sh script for variable declaration and validation
source "${ROOT}/scripts/common.sh"

cd "${ROOT}/env"

# Select the environment workspace where you want destroy all your resources
terraform workspace select "${TF_VAR_environment:-}"

# this will destroy all of your resources in the environment workspace
terraform destroy -no-color -auto-approve

# Delete terraform workspace.
terraform workspace select default
terraform workspace delete "${TF_VAR_environment:-}"

# Cleanup state bucket
aws s3api delete-bucket --bucket "${BUCKET_NAME}" --region "${TF_VAR_region:-}" >/dev/null