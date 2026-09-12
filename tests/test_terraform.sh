# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

#!/usr/bin/env bash
set -euo pipefail

command -v terraform >/dev/null 2>&1 || {
  echo "Terraform is required for this test."
  exit 1
}

cd terraform
terraform fmt -check -recursive
terraform init -backend=false
terraform validate


