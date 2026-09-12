# Habot Secure DevOps Hiring Project

**Candidate:** Niraj Yadav  
**Role:** Junior Cloud and DevOps Engineer — Google Cloud Platform, Django, React

> Contact information was not present in the supplied hiring-project source material. The final submission must include the candidate's real email address and phone number in this header and at the top of the submitted code/document files.

## Scope

This repository implements the three concrete tasks from the HabotConnect hiring project:

1. Secure Terraform provisioning for the D0 Raw Landing storage bucket and D1 Staged/Enforced BigQuery dataset, including customer-managed encryption, strict access control, and row-level security.
2. Fail-Closed GitHub Actions gates for formatting, linting, secret detection, infrastructure security scanning, tests, and an authenticated Terraform plan. Missing deployment configuration is a hard failure rather than a successful skip.
3. Deterministic Django REST Framework validation and binary Yes/No decision logic for the student onboarding payload.

The design also includes the requested App Engine provisioning capability, a Pub/Sub to BigQuery streaming sink, dead-letter handling, remote Terraform state bootstrap, and GitHub OpenID Connect Workload Identity Federation.

## Important configuration inputs

No fake cloud identifiers are committed. The following values are supplied through environment variables or GitHub repository configuration:

- Google Cloud project identifier
- Globally unique D0 bucket name
- Analytics Google Group email address
- Terraform state bucket name
- GitHub OpenID Connect provider resource name
- GitHub deployment service account email

The GitHub repository name is taken directly from the GitHub Actions context and is not hardcoded.

## Bootstrap order

### 1. Create the Terraform state bucket

Run `bootstrap/state` once with an operator credential. The state bucket uses uniform bucket-level access, public-access prevention, versioning, and a lifecycle rule.

### 2. Configure the main Terraform variables

Set these environment variables for local execution:

```text
TF_VAR_project_id
TF_VAR_bucket_name
TF_VAR_analytics_group
TF_VAR_region
TF_VAR_data_region
TF_VAR_github_repository
```

### 3. Apply the main Terraform stack once with an operator credential

This creates the infrastructure, deployment identity, GitHub Workload Identity Federation provider, least-privilege deployment role, streaming resources, and security controls.

### 4. Configure GitHub

Repository variables:

- `GCP_PROJECT_ID`
- `GCP_BUCKET_NAME`
- `GCP_ANALYTICS_GROUP`
- `GCP_REGION`
- `GCP_DATA_REGION`
- `TF_STATE_BUCKET`

Repository secrets:

- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_DEPLOYER_SERVICE_ACCOUNT`

The production environment should also require an explicit reviewer approval.

### 5. Run the protected pipeline

Pull requests execute quality and security gates. Pushes to the main branch additionally execute an authenticated Terraform plan. The deployment workflow repeats the gates, requires the explicit `DEPLOY` confirmation, uses the protected production environment, and applies only the generated plan.

## Data flow

```text
Student onboarding JSON
        |
        v
Django REST Framework serializer
        |
        v
Strict field validation
        |
        v
Binary Yes/No decision logic
        |
        +---- ACCEPT ----> application data path
        |
        +---- REJECT ----> deterministic validation response

Streaming path:
Raw onboarding event -> Pub/Sub topic -> BigQuery raw landing table
                                  |
                                  +--> dead-letter topic for failed delivery

Analytics path:
D1 enforced table -> table IAM -> row-level security by data region
```

The Pub/Sub to BigQuery subscription uses the BigQuery table schema so message fields cannot silently drift from the declared streaming sink schema.

## Security model

- Customer-managed Cloud Key Management Service key for the D0 bucket.
- Uniform bucket-level access and public-access prevention.
- Bucket versioning and lifecycle controls.
- Separate identities for continuous integration and deployment, data pipeline, backend, analytics, and Pub/Sub to BigQuery delivery.
- Conditional storage access for workload identities.
- BigQuery table-level analytics access plus row-level filtering.
- GitHub OpenID Connect Workload Identity Federation instead of long-lived Google Cloud service-account keys.
- Dedicated Terraform deployment role instead of project Owner or Editor access.
- Fail-Closed gates: a failed quality or security check stops progression.

Google Cloud recommends Workload Identity Federation for external deployment systems such as GitHub because it avoids long-lived service-account keys.

## Validation

The repository contains:

- Django migration for the onboarding model.
- JSON Schema with `additionalProperties: false`.
- Deterministic binary Yes/No decision logic.
- Django tests for valid and invalid payloads.
- Schema validation tests.
- Terraform formatting and validation test script.
- Security scan test script.
- Submission structure and spreadsheet Wrap Text validation script.

## Presentation

`presentation/Habot_DevOps_Architecture.pptx` contains exactly 15 slides and covers the architecture, Poka-Yoke gates, data flow, security controls, schema mapping, failure scenarios, and evidence plan.

## Submission evidence

Before submitting, run the project in the candidate's own Google Cloud and GitHub environment and capture:

1. A successful protected pipeline run.
2. A formatting failure that blocks progression.
3. A hardcoded secret detection failure that blocks progression.
4. Terraform plan output after successful gates.
5. Google Cloud Storage D0 security configuration.
6. BigQuery row-level security behavior.
7. Pub/Sub to BigQuery streaming sink configuration.
8. Protected deployment approval and successful apply, if deployment access is available.

The repository does not fabricate live cloud evidence; those screenshots must come from the candidate's actual environment.
