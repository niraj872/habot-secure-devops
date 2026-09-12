# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

from django.urls import path
from .views import StudentOnboardingCreateView

urlpatterns = [
    path(
        "onboarding/", StudentOnboardingCreateView.as_view(), name="student-onboarding"
    ),
]
