#!/usr/bin/env bash
set -ex

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
  for provider in $(ls "${REPO_ROOT}/terraform/"); do
    cd "${REPO_ROOT}/terraform/${provider}/env"
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
  echo "Running tf lint"
  REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  for provider in $(ls "${REPO_ROOT}/terraform/"); do
    cd "${REPO_ROOT}/terraform/${provider}/env"
    tflint
  done
}

function check_tfsec() {
  echo "Running tf sec"
  REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  for provider in $(ls "${REPO_ROOT}/terraform/"); do
    cd "${REPO_ROOT}/terraform/${provider}/env"
    tfsec
  done
}
