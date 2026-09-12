# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

# Streaming ingestion path: validated onboarding events -> Pub/Sub -> BigQuery raw landing.
# The D0 storage bucket is the encrypted raw landing layer; the streaming sink is
# kept schema-explicit so transactional payloads cannot silently drift.

resource "google_pubsub_topic" "onboarding_raw" {
  project = var.project_id
  name    = "habot-onboarding-raw"

  labels = local.labels

  depends_on = [google_project_service.required]
}

resource "google_bigquery_table" "raw_events" {
  dataset_id          = google_bigquery_dataset.d1_staged_enforced.dataset_id
  table_id            = "raw_onboarding_events"
  project             = var.project_id
  deletion_protection = true

  schema = jsonencode([
    {
      name = "event_id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "payload"
      type = "JSON"
      mode = "REQUIRED"
    },
    {
      name = "published_at"
      type = "TIMESTAMP"
      mode = "REQUIRED"
    }
  ])
}

resource "google_service_account" "pubsub_bq_writer" {
  project      = var.project_id
  account_id   = "habot-pubsub-bq"
  display_name = "Habot Pub/Sub BigQuery writer"
}

resource "google_project_iam_member" "pubsub_bq_metadata_viewer" {
  project = var.project_id
  role    = "roles/bigquery.metadataViewer"
  member  = "serviceAccount:${google_service_account.pubsub_bq_writer.email}"
}

resource "google_project_iam_member" "pubsub_bq_data_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.pubsub_bq_writer.email}"
}

resource "google_pubsub_subscription" "raw_to_bigquery" {
  project = var.project_id
  name    = "habot-onboarding-raw-to-bq"
  topic   = google_pubsub_topic.onboarding_raw.id

  ack_deadline_seconds = 30

  bigquery_config {
    table                 = "${var.project_id}.${google_bigquery_dataset.d1_staged_enforced.dataset_id}.${google_bigquery_table.raw_events.table_id}"
    service_account_email = google_service_account.pubsub_bq_writer.email
    use_table_schema      = true
    write_metadata        = false
  }

  depends_on = [
    google_project_iam_member.pubsub_bq_metadata_viewer,
    google_project_iam_member.pubsub_bq_data_editor,
  ]
}

resource "google_pubsub_topic" "onboarding_dead_letter" {
  project = var.project_id
  name    = "habot-onboarding-dead-letter"
  labels  = local.labels
}

resource "google_pubsub_subscription" "raw_dead_letter" {
  project = var.project_id
  name    = "habot-onboarding-dead-letter-sub"
  topic   = google_pubsub_topic.onboarding_dead_letter.id

  message_retention_duration = "604800s"
}

output "onboarding_raw_topic" {
  description = "Raw onboarding Pub/Sub topic."
  value       = google_pubsub_topic.onboarding_raw.name
}

output "raw_bigquery_table" {
  description = "Streaming raw onboarding BigQuery table."
  value       = google_bigquery_table.raw_events.table_id
}

resource "google_project_service_identity" "pubsub" {
  provider = google-beta
  project  = var.project_id
  service  = "pubsub.googleapis.com"
}

resource "google_service_account_iam_member" "deployer_pubsub_writer_user" {
  service_account_id = google_service_account.pubsub_bq_writer.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.ci_cd.email}"
}

resource "google_service_account_iam_member" "pubsub_service_agent_token_creator" {
  service_account_id = google_service_account.pubsub_bq_writer.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_project_service_identity.pubsub.email}"
}

