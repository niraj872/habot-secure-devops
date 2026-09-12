# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

locals {
  dataset_id = "d1_staged_enforced"
  table_id   = "student_onboarding"

  labels = {
    environment = "staging"
    managed_by  = "terraform"
    project     = "habot-devops"
  }
}

resource "google_project_service" "required" {
  for_each = toset([
    "bigquery.googleapis.com",
    "cloudkms.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com",
    "appengine.googleapis.com",
    "pubsub.googleapis.com"
  ])

  service            = each.value
  disable_on_destroy = false
}


