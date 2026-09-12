# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

from django.urls import include, path

urlpatterns = [
    path("api/", include("onboarding.urls")),
]


