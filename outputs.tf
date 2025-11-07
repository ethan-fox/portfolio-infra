# API Backend Outputs
output "cloud_run_url" {
  description = "URL of the deployed Cloud Run service (private, use load balancer instead)"
  value       = module.api.cloud_run_url
}

output "artifact_registry_location" {
  description = "Location to push Docker images"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.backend.repository_id}"
}

output "database_url_secret_name" {
  description = "Name of the database URL secret in Secret Manager"
  value       = module.api.database_url_secret_name
}

# Frontend Outputs
output "frontend_bucket_name" {
  description = "Name of the Cloud Storage bucket for frontend (upload destination)"
  value       = module.ui.frontend_bucket_name
}

# Load Balancer Outputs
output "frontend_load_balancer_ip" {
  description = "Static IP for frontend load balancer - configure DNS: ethan-builds.com → this IP"
  value       = module.load_balancer.frontend_load_balancer_ip
}

output "backend_load_balancer_ip" {
  description = "Static IP for backend load balancer - configure DNS: api.ethan-builds.com → this IP"
  value       = module.load_balancer.backend_load_balancer_ip
}

output "frontend_url_map_name" {
  description = "Name of frontend URL map (for CDN cache invalidation)"
  value       = module.load_balancer.frontend_url_map_name
}

# GitHub Actions Service Account (unchanged)
output "github_actions_service_account" {
  description = "Service account email for GitHub Actions"
  value       = google_service_account.github_actions.email
}
