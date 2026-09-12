# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

PYTHON="/c/Users/admin/Downloads/Habot-Secure-DevOps-FINAL-2026/.venv/Scripts/python.exe"

if [ ! -f "$PYTHON" ]; then
    PYTHON="/c/Python314/python.exe"
fi

if [ ! -f "$PYTHON" ]; then
    echo "FAIL: Python is required."
    exit 1
fi

"$PYTHON" - <<'PY'
import json
from pathlib import Path
from openpyxl import load_workbook

root = Path.cwd()

required = [
    root / "terraform" / "main.tf",
    root / "terraform" / "bigquery.tf",
    root / "terraform" / "storage.tf",
    root / "terraform" / "wif.tf",
    root / "terraform" / "streaming.tf",
    root / ".github" / "workflows" / "ci.yml",
    root / ".github" / "workflows" / "deploy.yml",
    root / "backend" / "onboarding" / "migrations" / "0001_initial.py",
    root / "data" / "schema.json",
    root / "data" / "dcyn_mapping.xlsx",
    root / "presentation" / "Habot_DevOps_Architecture.pptx",
]

for path in required:
    if not path.exists():
        raise SystemExit(f"FAIL: Missing required file: {path.relative_to(root)}")

schema = json.loads((root / "data" / "schema.json").read_text(encoding="utf-8"))

if schema.get("additionalProperties") is not False:
    raise SystemExit("FAIL: schema.json additionalProperties must be false")

expected = {
    "student_id",
    "student_name",
    "age",
    "has_learning_difficulty",
    "requires_learning_support",
    "consent_given",
    "data_region",
}

if set(schema.get("required", [])) != expected:
    raise SystemExit("FAIL: schema.json required fields do not match expected fields")

wb = load_workbook(root / "data" / "dcyn_mapping.xlsx")

for ws in wb.worksheets:
    for row in ws.iter_rows():
        for cell in row:
            if cell.value is not None and not cell.alignment.wrap_text:
                raise SystemExit(
                    f"FAIL: Wrap Text disabled at {ws.title}!{cell.coordinate}"
                )

print("PASS: Submission structure, schema, and spreadsheet visibility checks passed.")
PY


