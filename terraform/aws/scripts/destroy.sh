#!/usr/bin/env bash
set -euo pipefail ${DEBUG:+-x}

# Locate the root directory
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export VAR_FILE="${1:-}"

# Run common.sh script for variable declaration and validation
# shellcheck source=/dev/null
source "${ROOT}/scripts/common.sh"

cd "${ROOT}/env"

prompt_confirm "Enter the environment name to destroy the environment" "${TF_VAR_workspace}" || exit 0

# Select the environment workspace where you want destroy all your resources
terraform workspace select "${TF_VAR_workspace}"

# this will destroy all of your resources in the environment workspace
# shellcheck disable=SC2086
terraform destroy -auto-approve ${TF_PARAMS:-}

# Delete terraform workspace.
terraform workspace select default
terraform workspace delete "${TF_VAR_workspace}"

echo -e "\n[INFO] Terraform state bucket should be deleted manually."
echo -e "[INFO] Run these commands to completely remove bucket and all versioned state files:\n"
echo "aws s3api delete-objects --bucket ${BUCKET_NAME} --region ${TF_VAR_region:-} --delete \"{\\\"Objects\\\": \$(aws s3api list-object-versions --bucket ${BUCKET_NAME} --region ${TF_VAR_region:-} --output json | jq -c '. | to_entries | [.[] | select(.key | match(\"^Versions|DeleteMarkers$\")) | .value[] | {Key:.Key,VersionId:.VersionId}]')}\""
echo "aws s3api delete-bucket --bucket ${BUCKET_NAME} --region ${TF_VAR_region:-}"