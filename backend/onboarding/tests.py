# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

from django.test import TestCase
from .dcyn import Decision, evaluate_onboarding
from .serializers import StudentOnboardingSerializer

VALID = {
    "student_id": "STU-1001",
    "student_name": "Student Example",
    "age": 12,
    "has_learning_difficulty": True,
    "requires_learning_support": True,
    "consent_given": True,
    "data_region": "IN-NCR",
}


class StudentOnboardingTests(TestCase):
    def test_valid_payload(self):
        serializer = StudentOnboardingSerializer(data=VALID)
        self.assertTrue(serializer.is_valid(), serializer.errors)

    def test_missing_required_field(self):
        payload = {**VALID}
        payload.pop("student_name")
        serializer = StudentOnboardingSerializer(data=payload)
        self.assertFalse(serializer.is_valid())

    def test_empty_name(self):
        serializer = StudentOnboardingSerializer(data={**VALID, "student_name": "   "})
        self.assertFalse(serializer.is_valid())

    def test_invalid_type(self):
        serializer = StudentOnboardingSerializer(data={**VALID, "age": "twelve"})
        self.assertFalse(serializer.is_valid())

    def test_out_of_range_age(self):
        serializer = StudentOnboardingSerializer(data={**VALID, "age": 150})
        self.assertFalse(serializer.is_valid())

    def test_invalid_yes_no_value(self):
        serializer = StudentOnboardingSerializer(data={**VALID, "consent_given": "YES"})
        self.assertFalse(serializer.is_valid())

    def test_consent_rejected(self):
        serializer = StudentOnboardingSerializer(data={**VALID, "consent_given": False})
        self.assertFalse(serializer.is_valid())

    def test_dcyn_accepts_valid_payload(self):
        result = evaluate_onboarding(VALID)
        self.assertEqual(result["decision"], Decision.ACCEPT.value)

    def test_dcyn_rejects_missing_field(self):
        payload = {**VALID}
        payload.pop("consent_given")
        result = evaluate_onboarding(payload)
        self.assertEqual(result["decision"], Decision.REJECT.value)
