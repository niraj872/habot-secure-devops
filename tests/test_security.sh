# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

#!/usr/bin/env bash
set -euo pipefail

echo "Checking for obvious hardcoded credential assignments..."
if grep -RInE --exclude-dir=.git --exclude='*.md' \
  '(api[_-]?key|api[_-]?secret|access[_-]?token)[[:space:]]*=[[:space:]]*["'\''][A-Za-z0-9_-]{20,}["'\'']' .; then
  echo "Security check failed: possible hardcoded credential found."
  exit 1
fi

echo "Security check passed."


