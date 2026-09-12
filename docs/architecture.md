# Architecture

```text
Developer
   |
   v
GitHub Actions
   |
   +--> Formatting / linting / secret scan / IaC scan / tests
   |
   +--> Authenticated Terraform plan
   |
   v
Google Cloud Platform
   |
   +--> D0 Raw Landing Storage Bucket -- customer-managed encryption
   |
   +--> D1 Staged/Enforced BigQuery
   |       |
   |       +--> table IAM
   |       +--> row-level security by data region
   |
   +--> Pub/Sub onboarding topic
   |       |
   |       +--> BigQuery streaming subscription
   |       +--> dead-letter topic
   |
   +--> Optional App Engine application bootstrap

Django REST Framework
   |
   +--> exact field validation
   +--> deterministic binary Yes/No logic
   +--> accepted/rejected decision
```

GitHub Actions uses OpenID Connect Workload Identity Federation rather than a long-lived Google Cloud service-account key.
