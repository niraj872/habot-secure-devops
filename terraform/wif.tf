# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

# GitHub Actions OIDC / Workload Identity Federation.
# Bootstrap once with an administrator/operator credential, then GitHub can use
# short-lived credentials without storing a GCP service-account key.
resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"
  description               = "OIDC identities for the Habot GitHub repository"
  disabled                  = false
  depends_on                = [google_project_service.required]
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-oidc"
  display_name                       = "GitHub OIDC"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
    "attribute.workflow"   = "assertion.workflow"
  }

  attribute_condition = "assertion.repository == '${var.github_repository}' && (assertion.ref == 'refs/heads/main' || assertion.ref.startsWith('refs/tags/'))"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  depends_on = [google_iam_workload_identity_pool.github]
}

resource "google_service_account_iam_member" "github_wif_deployer" {
  service_account_id = google_service_account.ci_cd.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_repository}"
}

output "github_workload_identity_provider" {
  description = "Full provider resource name for GitHub Actions OIDC."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "github_deployer_service_account" {
  description = "GitHub Actions deployment service account email."
  value       = google_service_account.ci_cd.email
}


