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

  shop_with_mom_oauth_web_secret = var.shop_with_mom_oauth_web_secret
  shop_with_mom_jwt_secret       = var.shop_with_mom_jwt_secret

  depends_on = [
    google_secret_manager_secret.database_url
  ]
}
