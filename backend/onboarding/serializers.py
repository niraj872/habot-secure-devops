# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

from rest_framework import serializers

from .dcyn import evaluate_onboarding
from .models import StudentOnboarding
from .validators import validate_age, validate_strict_boolean, validate_student_name


class StrictBooleanField(serializers.Field):
    """
    Accept only real JSON booleans: true or false.
    Strings such as "YES", "NO", "true", and "false" are rejected.
    """

    default_error_messages = {
        "invalid": "This field must be a Boolean value: true or false."
    }

    def to_internal_value(self, data):
        return validate_strict_boolean(data)

    def to_representation(self, value):
        return bool(value)


class StudentOnboardingSerializer(serializers.ModelSerializer):
    student_name = serializers.CharField(
        min_length=1,
        max_length=100,
        allow_blank=False,
        trim_whitespace=True,
        validators=[validate_student_name],
    )

    age = serializers.IntegerField(
        min_value=3,
        max_value=25,
        validators=[validate_age],
    )

    has_learning_difficulty = StrictBooleanField()
    requires_learning_support = StrictBooleanField()
    consent_given = StrictBooleanField()

    class Meta:
        model = StudentOnboarding
        fields = [
            "student_id",
            "student_name",
            "age",
            "has_learning_difficulty",
            "requires_learning_support",
            "consent_given",
            "data_region",
        ]
        extra_kwargs = {
            "student_id": {
                "required": True,
                "max_length": 64,
            },
            "data_region": {
                "required": True,
                "max_length": 32,
            },
        }

    def validate(self, attrs):
        decision = evaluate_onboarding(attrs)

        if decision["decision"] != "ACCEPT":
            raise serializers.ValidationError({"dcyn": decision})

        return attrs
