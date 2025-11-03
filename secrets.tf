# Secret Manager Secrets
# Stores sensitive configuration values for Cloud Run services

resource "google_secret_manager_secret" "database_url" {
  secret_id = "database-url"

  replication {
    auto {}
  }

  depends_on = [google_project_service.secret_manager]
}
