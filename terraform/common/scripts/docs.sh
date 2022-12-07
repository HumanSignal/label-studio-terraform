#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

# Locate the root directory
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

for package in aws common; do
  for module in $(ls "${ROOT}/${package}/modules"); do
    terraform-docs markdown table --output-file README.md --output-mode inject "${ROOT}/${package}/modules/${module}"
  done
done

terraform-docs markdown table --output-file README.md --output-mode inject "${ROOT}/aws/env"
