#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

prompt_confirm() {
  while true; do
    read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
    case $REPLY in
      [yY]) echo ; return 0 ;;
      [nN]) echo ; return 1 ;;
      *) printf " \033[31m %s \n\033[0m" "invalid input"
    esac
  done
}

# Locate the root directory
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Run common.sh script for variable declaration and validation
source "${ROOT}/scripts/common.sh"

cd "${ROOT}/env"

prompt_confirm "Are you sure you what to destroy the environment?" || exit 0
prompt_confirm "ARE YOU SURE?" || exit 0

# Select the environment workspace where you want destroy all your resources
terraform workspace select "${TF_VAR_environment:-}"

# this will destroy all of your resources in the environment workspace
terraform destroy -no-color -auto-approve ${TF_PARAMS}

# Delete terraform workspace.
terraform workspace select default
terraform workspace delete "${TF_VAR_environment:-}"

# Cleanup state bucket
# TODO: ERROR: An error occurred (BucketNotEmpty) when calling the DeleteBucket operation: The bucket you tried to delete is not empty. You must delete all versions in the bucket.
aws s3api delete-bucket --bucket "${BUCKET_NAME}" --region "${TF_VAR_region:-}" >/dev/null