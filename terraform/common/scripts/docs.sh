#!/usr/bin/env bash
set -euo pipefail ${DEBUG:+-x}

# Locate the root directory
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

for package in aws common; do
  for module in "${ROOT}"/"${package}"/modules/*; do
    terraform-docs markdown table --output-file README.md --output-mode inject "${module}"
  done
done

terraform-docs markdown table --output-file README.md --output-mode inject "${ROOT}/aws/env"
