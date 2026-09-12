# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

resource "google_bigquery_dataset" "d1_staged_enforced" {
  dataset_id                 = local.dataset_id
  project                    = var.project_id
  location                   = var.region
  delete_contents_on_destroy = false
  labels                     = local.labels

  depends_on = [google_project_service.required]
}

resource "google_bigquery_table" "student_onboarding" {
  dataset_id          = google_bigquery_dataset.d1_staged_enforced.dataset_id
  table_id            = local.table_id
  project             = var.project_id
  deletion_protection = true

  schema = jsonencode([
    { name = "student_id", type = "STRING", mode = "REQUIRED" },
    { name = "student_name", type = "STRING", mode = "REQUIRED" },
    { name = "age", type = "INTEGER", mode = "REQUIRED" },
    { name = "has_learning_difficulty", type = "BOOLEAN", mode = "REQUIRED" },
    { name = "requires_learning_support", type = "BOOLEAN", mode = "REQUIRED" },
    { name = "consent_given", type = "BOOLEAN", mode = "REQUIRED" },
    { name = "data_region", type = "STRING", mode = "REQUIRED" },
    { name = "created_at", type = "TIMESTAMP", mode = "REQUIRED" }
  ])
}

resource "google_bigquery_table_iam_member" "analytics_viewer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.d1_staged_enforced.dataset_id
  table_id   = google_bigquery_table.student_onboarding.table_id
  role       = "roles/bigquery.dataViewer"
  member     = "group:${var.analytics_group}"
}

resource "google_bigquery_row_access_policy" "analytics_region_policy" {
  project          = var.project_id
  dataset_id       = google_bigquery_dataset.d1_staged_enforced.dataset_id
  table_id         = google_bigquery_table.student_onboarding.table_id
  policy_id        = "analytics_region_policy"
  filter_predicate = "data_region = '${var.data_region}'"
  grantees         = ["group:${var.analytics_group}"]
}


