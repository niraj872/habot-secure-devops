# Security Model

## Least privilege
The project separates identities for CI/CD, the data pipeline, backend application and analytics.

## IAM Conditions
Storage object access is restricted to defined object prefixes. This limits the blast radius of a compromised workload identity.

## Secret management
No real credentials are stored in source control. Real deployments should use GitHub OIDC/Workload Identity Federation and a managed secret store where application secrets are required.

## GCS
- Uniform bucket-level access
- Public access prevention
- Versioning
- Lifecycle control
- Cloud KMS encryption

## BigQuery
The student table has an explicit schema. Analytics users receive table data-view permissions and are additionally constrained by a row access policy.

## RLS
The example policy permits the analytics group to see rows whose `data_region` equals `IN-NCR`. This demonstrates data minimization at query time.

## Fail-Closed
Formatting, linting, infrastructure validation, secret scanning, IaC security scanning and tests are mandatory gates. The plan job depends on the complete gate job.

## Why real secrets must never be committed
Repository history is durable and may be copied or cached. A secret must therefore be prevented from entering the repository rather than relying on later deletion.
