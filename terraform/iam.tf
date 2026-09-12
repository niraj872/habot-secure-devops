# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

resource "google_service_account" "ci_cd" {
  account_id   = "habot-ci-cd"
  display_name = "Habot CI/CD deployment identity"
  project      = var.project_id
}

resource "google_service_account" "data_pipeline" {
  account_id   = "habot-data-pipeline"
  display_name = "Habot data pipeline identity"
  project      = var.project_id
}

resource "google_service_account" "backend" {
  account_id   = "habot-backend"
  display_name = "Habot backend workload identity"
  project      = var.project_id
}

resource "google_service_account" "analytics" {
  account_id   = "habot-analytics"
  display_name = "Habot read-only analytics identity"
  project      = var.project_id
}

resource "google_project_iam_member" "data_pipeline_bigquery_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.data_pipeline.email}"
}

resource "google_project_iam_member" "backend_bigquery_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_storage_bucket_iam_member" "data_pipeline_object_admin" {
  bucket = google_storage_bucket.d0_raw_landing.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.data_pipeline.email}"

  condition {
    title       = "D0 object path restriction"
    description = "Data pipeline can manage objects only under the d0 prefix."
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.d0_raw_landing.name}/objects/d0/\")"
  }
}

resource "google_storage_bucket_iam_member" "backend_object_viewer" {
  bucket = google_storage_bucket.d0_raw_landing.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.backend.email}"

  condition {
    title       = "Validated object read restriction"
    description = "Backend can read only validated objects."
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.d0_raw_landing.name}/objects/validated/\")"
  }
}

resource "google_bigquery_dataset_iam_member" "data_pipeline_editor" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.d1_staged_enforced.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.data_pipeline.email}"
}

resource "google_bigquery_dataset_iam_member" "backend_viewer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.d1_staged_enforced.dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_bigquery_dataset_iam_member" "analytics_viewer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.d1_staged_enforced.dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:${google_service_account.analytics.email}"
}

resource "google_service_account_iam_member" "ci_impersonates_pipeline" {
  service_account_id = google_service_account.data_pipeline.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.ci_cd.email}"
}


