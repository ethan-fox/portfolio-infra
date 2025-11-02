output "cloud_run_url" {
  description = "URL of the deployed Cloud Run service"
  value       = module.cloud_run.service_url
}

output "artifact_registry_location" {
  description = "Location to push Docker images"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.backend.repository_id}"
}

output "github_actions_service_account" {
  description = "Service account email for GitHub Actions"
  value       = google_service_account.github_actions.email
}

output "database_url_secret_name" {
  description = "Name of the database URL secret in Secret Manager"
  value       = google_secret_manager_secret.database_url.secret_id
}

output "api_keys_secret_name" {
  description = "Name of the API keys secret in Secret Manager"
  value       = google_secret_manager_secret.api_keys.secret_id
}
