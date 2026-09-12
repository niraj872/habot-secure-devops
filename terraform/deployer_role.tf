# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

# Dedicated deployment role instead of roles/editor/roles/owner.
# This role is intentionally project-scoped and contains only permissions used by
# the Terraform-managed platform resources. Creation/update of the role itself
# requires an operator/bootstrap identity with IAM admin privileges.
resource "google_project_iam_custom_role" "terraform_deployer" {
  project     = var.project_id
  role_id     = "habotTerraformDeployer"
  title       = "Habot Terraform Deployer"
  description = "Least-privilege project deployment role for the Habot Terraform stack."

  permissions = [
    "serviceusage.services.get",
    "serviceusage.services.list",
    "serviceusage.services.enable",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.projects.setIamPolicy",
    "storage.buckets.create",
    "storage.buckets.delete",
    "storage.buckets.get",
    "storage.buckets.list",
    "storage.buckets.update",
    "storage.buckets.getIamPolicy",
    "storage.buckets.setIamPolicy",
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.list",
    "bigquery.datasets.create",
    "bigquery.datasets.delete",
    "bigquery.datasets.get",
    "bigquery.datasets.update",
    "bigquery.datasets.getIamPolicy",
    "bigquery.datasets.setIamPolicy",
    "bigquery.tables.create",
    "bigquery.tables.delete",
    "bigquery.tables.get",
    "bigquery.tables.update",
    "bigquery.tables.getData",
    "bigquery.tables.updateData",
    "bigquery.tables.getIamPolicy",
    "bigquery.tables.setIamPolicy",
    "bigquery.jobs.create",
    "bigquery.rowAccessPolicies.create",
    "bigquery.rowAccessPolicies.delete",
    "bigquery.rowAccessPolicies.get",
    "bigquery.rowAccessPolicies.list",
    "bigquery.rowAccessPolicies.setIamPolicy",
    "bigquery.rowAccessPolicies.update",
    "cloudkms.keyRings.create",
    "cloudkms.keyRings.get",
    "cloudkms.keyRings.list",
    "cloudkms.cryptoKeys.create",
    "cloudkms.cryptoKeys.get",
    "cloudkms.cryptoKeys.update",
    "cloudkms.cryptoKeys.getIamPolicy",
    "cloudkms.cryptoKeys.setIamPolicy",
    "pubsub.topics.create",
    "pubsub.topics.delete",
    "pubsub.topics.get",
    "pubsub.topics.list",
    "pubsub.topics.update",
    "pubsub.topics.getIamPolicy",
    "pubsub.topics.setIamPolicy",
    "pubsub.subscriptions.create",
    "pubsub.subscriptions.delete",
    "pubsub.subscriptions.get",
    "pubsub.subscriptions.list",
    "pubsub.subscriptions.update",
    "pubsub.subscriptions.getIamPolicy",
    "pubsub.subscriptions.setIamPolicy",
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.delete",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.list",
    "iam.serviceAccounts.update",
    "iam.serviceAccounts.getIamPolicy",
    "iam.serviceAccounts.setIamPolicy",
    "iam.workloadIdentityPools.create",
    "iam.workloadIdentityPools.delete",
    "iam.workloadIdentityPools.get",
    "iam.workloadIdentityPools.list",
    "iam.workloadIdentityPools.update",
    "iam.workloadIdentityPoolProviders.create",
    "iam.workloadIdentityPoolProviders.delete",
    "iam.workloadIdentityPoolProviders.get",
    "iam.workloadIdentityPoolProviders.list",
    "iam.workloadIdentityPoolProviders.update",
    "appengine.applications.get",
    "appengine.applications.create",
    "appengine.applications.update",
  ]
}

resource "google_project_iam_member" "terraform_deployer" {
  project = var.project_id
  role    = google_project_iam_custom_role.terraform_deployer.name
  member  = "serviceAccount:${google_service_account.ci_cd.email}"
}


