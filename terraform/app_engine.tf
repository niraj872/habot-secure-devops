# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

# Optional App Engine bootstrap for environments where the project does not
# already have an App Engine application. Keep false when the target project
# already owns an App Engine application because GCP permits only one per project.
resource "google_app_engine_application" "backend" {
  count         = var.enable_app_engine ? 1 : 0
  project       = var.project_id
  location_id   = var.app_engine_location
  database_type = "CLOUD_FIRESTORE"

  depends_on = [google_project_service.required]
}


