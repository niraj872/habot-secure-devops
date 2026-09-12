# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "backend"))

from onboarding.dcyn import Decision, evaluate_onboarding  # noqa: E402

VALID = {
    "student_id": "STU-1001",
    "student_name": "Student Example",
    "age": 12,
    "has_learning_difficulty": True,
    "requires_learning_support": True,
    "consent_given": True,
    "data_region": "IN-NCR",
}


def test_accepts_valid_payload():
    assert evaluate_onboarding(VALID)["decision"] == Decision.ACCEPT.value


def test_rejects_missing_field():
    payload = {**VALID}
    payload.pop("consent_given")
    assert evaluate_onboarding(payload)["decision"] == Decision.REJECT.value


def test_rejects_non_boolean_yes_no_value():
    payload = {**VALID, "consent_given": "YES"}
    assert evaluate_onboarding(payload)["decision"] == Decision.REJECT.value


def test_rejects_without_consent():
    payload = {**VALID, "consent_given": False}
    assert evaluate_onboarding(payload)["decision"] == Decision.REJECT.value


