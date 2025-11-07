# Cloud Run Service
# Serverless container deployment for portfolio API

module "cloud_run" {
  source = "../modules/cloud-run"

  project_id    = var.project_id
  region        = var.region
  service_name  = var.service_name
  image         = var.docker_image
  min_instances = var.min_instances
  max_instances = var.max_instances
  environment   = var.environment
  log_level     = var.log_level

  database_url_secret = google_secret_manager_secret.database_url.secret_id
  api_key_secret      = google_secret_manager_secret.api_key.secret_id

  depends_on = [
    google_secret_manager_secret.database_url,
    google_secret_manager_secret.api_key
  ]
}
