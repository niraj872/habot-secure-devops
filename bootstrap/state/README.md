# Terraform state bootstrap

Run this once with an operator credential before using the main stack in CI/CD.

Set the following environment variables in the shell:

```bash
export TF_VAR_project_id="$(gcloud config get-value project)"
export TF_VAR_state_bucket_name="$(python -c 'import secrets; print("habot-tf-state-" + secrets.token_hex(6))')"
```

Then run:

```bash
terraform init
terraform apply \
  -var="project_id=${TF_VAR_project_id}" \
  -var="state_bucket_name=${TF_VAR_state_bucket_name}"
```

The state bucket uses uniform bucket-level access, public-access prevention, versioning, and a lifecycle rule. Configure the resulting bucket name as the GitHub repository variable `TF_STATE_BUCKET`.
