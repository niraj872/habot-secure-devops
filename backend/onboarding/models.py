# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

from django.db import models


class StudentOnboarding(models.Model):
    student_id = models.CharField(max_length=64, unique=True)
    student_name = models.CharField(max_length=100)
    age = models.PositiveSmallIntegerField()
    has_learning_difficulty = models.BooleanField()
    requires_learning_support = models.BooleanField()
    consent_given = models.BooleanField()
    data_region = models.CharField(max_length=32, default="IN-NCR")
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]
