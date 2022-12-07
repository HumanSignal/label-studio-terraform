#!/usr/bin/env bash
set -euo pipefail ${DEBUG:+-x}

# This function checks to make sure that every
# shebang has a '- e' flag, which causes it
# to exit on error
function check_bash() {
  find . -name "*.sh" | while IFS= read -d '' -r file; do
    if [[ "$file" != *"bash -e"* ]]; then
      echo "$file is missing shebang with -e"
      exit 1
    fi
  done
}

# This function runs 'terraform validate' against all
# files ending in '.tf'
function check_terraform() {
  echo "Running terraform validate"
  REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  for provider in "${REPO_ROOT}"/terraform/*; do
    [[ "$provider" == "common" ]] && continue
    cd "${provider}/env"
    terraform init -backend=false
    terraform validate .
  done
}

# This function runs the shellcheck linter on every
# file ending in '.sh'
function check_shell() {
  echo "Running shellcheck"
  find . -name "*.sh" -exec shellcheck -x {} \;
}

function check_tflint() {
  # tflint is installed
  command -v tflint >/dev/null 2>&1 || { \
   echo >&2 "tflint is required for this check but it's not installed.  Aborting."
   echo >&2 "Refer to: https://github.com/terraform-linters/tflint"
   exit 1
  }
  echo "Running tflint"
  REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  for provider in "${REPO_ROOT}"/terraform/*; do
    [[ "$provider" == "common" ]] && continue
    cd "${provider}/env"
    tflint
  done
}

function check_tfsec() {
  # tfsec is installed
  command -v tfsec >/dev/null 2>&1 || { \
   echo >&2 "tfsec is required for this check but it's not installed.  Aborting."
   echo >&2 "Refer to: https://github.com/aquasecurity/tfsec"
   exit 1
  }
  echo "Running tfsec"
  REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  for provider in "${REPO_ROOT}"/terraform/*; do
    [[ "$provider" == "common" ]] && continue
    cd "${provider}/env"
    tfsec
  done
}
