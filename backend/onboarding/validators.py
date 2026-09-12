# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

from rest_framework import serializers

MIN_AGE = 3
MAX_AGE = 25
MIN_NAME_LENGTH = 1
MAX_NAME_LENGTH = 100


def validate_student_name(value):
    value = value.strip()
    if not value:
        raise serializers.ValidationError("Student name must not be empty.")
    if not MIN_NAME_LENGTH <= len(value) <= MAX_NAME_LENGTH:
        raise serializers.ValidationError(
            f"Student name must contain {MIN_NAME_LENGTH}-{MAX_NAME_LENGTH} characters."
        )
    return value


def validate_age(value):
    if not MIN_AGE <= value <= MAX_AGE:
        raise serializers.ValidationError(
            f"Age must be between {MIN_AGE} and {MAX_AGE}."
        )
    return value


def validate_strict_boolean(value):
    if type(value) is not bool:
        raise serializers.ValidationError("Value must be a Boolean.")
    return value
