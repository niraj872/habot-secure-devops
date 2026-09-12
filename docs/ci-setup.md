# Continuous Integration and Deployment Setup

## GitHub repository variables

- `GCP_PROJECT_ID`
- `GCP_BUCKET_NAME`
- `GCP_ANALYTICS_GROUP`
- `GCP_REGION`
- `GCP_DATA_REGION`
- `TF_STATE_BUCKET`

## GitHub repository secrets

- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_DEPLOYER_SERVICE_ACCOUNT`

The GitHub repository itself is supplied automatically through the GitHub Actions `github.repository` context.

## Fail-Closed behavior

The quality and security job is mandatory. Formatting, linting, Terraform validation, secret detection, infrastructure security scanning, Django tests, or schema tests failing stops progression.

For main-branch pushes and manual runs, the authenticated Terraform plan job then requires every cloud configuration value and authentication value. Missing configuration is a hard failure; there is no successful skip path.

The deployment workflow repeats the same gates, authenticates through Workload Identity Federation, creates a remote-state Terraform plan, and applies only that plan after explicit `DEPLOY` confirmation and the protected production environment approval.
