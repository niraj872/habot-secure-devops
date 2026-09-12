# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

output "d0_raw_landing_bucket" {
  description = "D0 Raw Landing bucket."
  value       = google_storage_bucket.d0_raw_landing.name
}

output "d1_staged_enforced_dataset" {
  description = "D1 Staged/Enforced dataset."
  value       = google_bigquery_dataset.d1_staged_enforced.dataset_id
}

output "service_accounts" {
  description = "Workload service accounts."
  value = {
    ci_cd         = google_service_account.ci_cd.email
    data_pipeline = google_service_account.data_pipeline.email
    backend       = google_service_account.backend.email
    analytics     = google_service_account.analytics.email
  }
}


