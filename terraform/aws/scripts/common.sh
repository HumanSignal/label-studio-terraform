#!/usr/bin/env bash
# Common commands for aws scripts
# shellcheck disable=SC2034
# shellcheck disable=SC1083

# Locate the root directory. Used by scripts that source this one.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# AWS CLI v2 is installed
command -v aws > /dev/null 2>&1 || {
  echo >&2 "AWS CLI v2 is required, but it's not installed.  Aborting."
  echo >&2 "Refer to: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html"
  exit 1
}

# kubectl is installed
command -v kubectl unbound variable > /dev/null 2>&1 || {
  echo >&2 "kubectl is required, but it's not installed.  Aborting."
  echo >&2 "Refer to: https://kubernetes.io/docs/tasks/tools/install-kubectl/"
  exit 1
}

# Helm is installed
command -v helm > /dev/null 2>&1 || {
  echo >&2 "helm is required but it's not installed.  Aborting."
  echo >&2 "Refer to: https://helm.sh/docs/intro/install/"
  exit 1
}

if [ -z "${VAR_FILE:-}" ]; then
  echo "[ERROR] This step requires to export the following variables VAR_FILE"
  exit 1
else
  if [ -f "${VAR_FILE}" ]; then
    echo -e "[INFO] Using '${VAR_FILE}' as a TF var file"
  else
    echo "[ERROR] TF var file '${VAR_FILE}' could no be found"
    exit 1
  fi
fi

TF_PARAMS="-var-file=${VAR_FILE} ${ADDITIONAL_TF_PARAMS:-}"
TF_VAR_environment=$(sed -n 's#^[ ]*environment[ ]*=[ ]*"\(.*\)"#\1#p' "${VAR_FILE}" | head -n 1)
TF_VAR_name=$(sed -n 's#^[ ]*name[ ]*=[ ]*"\(.*\)"#\1#p' "${VAR_FILE}" | head -n 1)
TF_VAR_region=$(sed -n 's#^[ ]*region[ ]*=[ ]*"\(.*\)"#\1#p' "${VAR_FILE}" | head -n 1)

export TF_PARAMS TF_VAR_environment TF_VAR_name TF_VAR_region

# Make sure you initialize the following TF_VAR's before you initialize the environment
if [ -z "${TF_VAR_environment:-}" ] || [ -z "${TF_VAR_name:-}" ] || [ -z "${TF_VAR_region:-}" ] || [ -z "${TF_PARAMS:-}" ]; then
  echo "[ERROR] This step requires to export the following variables TF_VAR_environment, TF_VAR_name, TF_VAR_region, TF_PARAMS"
  exit 1
else
  echo -e "[INFO] The following variables are configured:\n  TF_VAR_environment: ${TF_VAR_environment}\n  TF_VAR_name: ${TF_VAR_name}\n  TF_VAR_region: ${TF_VAR_region}\n  TF_PARAMS: ${TF_PARAMS}"
fi

# Create s3 state bucket if not exist
export BUCKET_NAME=${TF_VAR_environment}-${TF_VAR_region}-ls-terraform-state-bucket
# shellcheck disable=SC2046
if ! aws s3api head-bucket --bucket "${BUCKET_NAME}" --region "${TF_VAR_region}" > /dev/null 2>&1; then
  echo "[INFO] Creating S3 bucket to store Terraform state: ${BUCKET_NAME}"
  aws s3api create-bucket --bucket "${BUCKET_NAME}" --region "${TF_VAR_region}" $( [[ "${TF_VAR_region}" != "us-east-1" ]] && echo "--create-bucket-configuration LocationConstraint=${TF_VAR_region}" ) > /dev/null
  aws s3api put-bucket-encryption \
    --bucket "${BUCKET_NAME}" \
    --server-side-encryption-configuration={\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]} > /dev/null
  aws s3api put-bucket-versioning --bucket "${BUCKET_NAME}" --versioning-configuration Status=Enabled > /dev/null
fi

echo "[INFO] Using s3 bucket to store terraform state: ${BUCKET_NAME}"
