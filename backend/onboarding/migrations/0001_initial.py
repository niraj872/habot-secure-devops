# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

from django.db import migrations, models


class Migration(migrations.Migration):
    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="StudentOnboarding",
            fields=[
                ("id", models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name="ID")),
                ("student_id", models.CharField(max_length=64, unique=True)),
                ("student_name", models.CharField(max_length=100)),
                ("age", models.PositiveSmallIntegerField()),
                ("has_learning_difficulty", models.BooleanField()),
                ("requires_learning_support", models.BooleanField()),
                ("consent_given", models.BooleanField()),
                ("data_region", models.CharField(default="IN-NCR", max_length=32)),
                ("created_at", models.DateTimeField(auto_now_add=True)),
            ],
            options={"ordering": ["-created_at"]},
        ),
    ]


