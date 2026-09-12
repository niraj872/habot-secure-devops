# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

import json
from pathlib import Path
from jsonschema import Draft202012Validator

ROOT = Path(__file__).resolve().parents[1]
payload = json.loads((ROOT / "data/student_onboarding.json").read_text())
schema = json.loads((ROOT / "data/schema.json").read_text())

errors = sorted(Draft202012Validator(schema).iter_errors(payload), key=lambda e: e.path)
if errors:
    for error in errors:
        print(error.message)
    raise SystemExit(1)

event_schema = json.loads((ROOT / "data/pubsub_event_schema.json").read_text())
event = {
    "event_id": payload["student_id"],
    "payload": payload,
    "published_at": "2026-09-11T10:00:00Z",
}
event_errors = sorted(Draft202012Validator(event_schema).iter_errors(event), key=lambda e: e.path)
if event_errors:
    for error in event_errors:
        print(error.message)
    raise SystemExit(1)

print("JSON schema validation passed for transactional and streaming event contracts.")


