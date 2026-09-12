# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

# Production/staging must provide DJANGO_SECRET_KEY through the runtime secret store.
# The fallback is intentionally non-secret and only exists so local tests can run.
SECRET_KEY = os.getenv("DJANGO_SECRET_KEY", "local-development-key")
DEBUG = os.getenv("DJANGO_DEBUG", "false").lower() == "true"
ALLOWED_HOSTS = [h.strip() for h in os.getenv("DJANGO_ALLOWED_HOSTS", "127.0.0.1,localhost").split(",") if h.strip()]

INSTALLED_APPS = [
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "corsheaders",
    "rest_framework",
    "onboarding",
]

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
]
ROOT_URLCONF = "habot_project.urls"
TEMPLATES = []
WSGI_APPLICATION = "habot_project.wsgi.application"

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "db.sqlite3",
    }
}

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
USE_TZ = True
TIME_ZONE = "Asia/Kolkata"


CORS_ALLOWED_ORIGINS = [
    "http://127.0.0.1:5173",
    "http://127.0.0.1:5174",
    "http://localhost:5173",
    "http://localhost:5174",
]


CORS_ALLOW_ALL_ORIGINS = True


