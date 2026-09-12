# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

from enum import Enum


class Decision(str, Enum):
    ACCEPT = "ACCEPT"
    REJECT = "REJECT"


YES_NO_FIELDS = (
    "has_learning_difficulty",
    "requires_learning_support",
    "consent_given",
)


def to_yes_no(value: bool) -> str:
    if type(value) is not bool:
        raise ValueError("DCYN accepts only Boolean values.")
    return "YES" if value else "NO"


def evaluate_onboarding(payload: dict) -> dict:
    missing = [field for field in YES_NO_FIELDS if field not in payload]
    if missing:
        return {
            "decision": Decision.REJECT.value,
            "reason": "Missing required Yes/No fields.",
            "missing_fields": missing,
        }

    invalid = [field for field in YES_NO_FIELDS if type(payload[field]) is not bool]
    if invalid:
        return {
            "decision": Decision.REJECT.value,
            "reason": "One or more Yes/No fields are not Boolean values.",
            "invalid_fields": invalid,
        }

    if payload["consent_given"] is not True:
        return {
            "decision": Decision.REJECT.value,
            "reason": "Required consent was not provided.",
        }

    return {
        "decision": Decision.ACCEPT.value,
        "reason": "Required deterministic onboarding rules passed.",
        "answers": {field: to_yes_no(payload[field]) for field in YES_NO_FIELDS},
    }
