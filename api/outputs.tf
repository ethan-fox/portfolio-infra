output "cloud_run_url" {
  description = "URL of the deployed Cloud Run service"
  value       = module.cloud_run.service_url
}

output "cloud_run_service_name" {
  description = "Name of the Cloud Run service"
  value       = module.cloud_run.service_name
}

output "cloud_run_region" {
  description = "Region of the Cloud Run service"
  value       = module.cloud_run.region
}

output "database_url_secret_name" {
  description = "Name of the database URL secret in Secret Manager"
  value       = google_secret_manager_secret.database_url.secret_id
}
