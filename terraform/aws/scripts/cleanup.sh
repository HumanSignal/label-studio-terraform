#!/usr/bin/env bash
set -euo pipefail ${DEBUG:+-x}

prompt_confirm "Enter the Terraform state bucket name to cleanup state" "${BUCKET_NAME:-}" || exit 0

aws s3api delete-objects --bucket ${BUCKET_NAME} --region ${TF_VAR_region:-} --delete \"{\\\"Objects\\\": \$(aws s3api list-object-versions --bucket ${BUCKET_NAME} --region ${TF_VAR_region:-} --output json | jq -c '. | to_entries | [.[] | select(.key | match(\"^Versions|DeleteMarkers$\")) | .value[] | {Key:.Key,VersionId:.VersionId}]')}\"
aws s3api delete-bucket --bucket ${BUCKET_NAME} --region ${TF_VAR_region:-}
