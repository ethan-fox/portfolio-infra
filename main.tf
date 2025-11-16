# Portfolio Infrastructure - Main Configuration
# OpenTofu version and provider configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# API Backend Resources
module "api" {
  source = "./api"

  project_id    = var.project_id
  region        = var.region
  service_name  = var.service_name
  docker_image  = var.docker_image
  min_instances = var.min_instances
  max_instances = var.max_instances
  environment   = var.environment
  log_level     = var.log_level

  google_oauth_client_id     = var.google_oauth_client_id
  google_oauth_client_secret = var.google_oauth_client_secret
}

# UI Frontend Resources
module "ui" {
  source = "./ui"

  project_id           = var.project_id
  region               = var.region
  frontend_bucket_name = var.frontend_bucket_name
  domain_name          = var.domain_name
}

# Load Balancer Resources
module "load_balancer" {
  source = "./load-balancer"

  project_id             = var.project_id
  region                 = var.region
  frontend_bucket_name   = module.ui.frontend_bucket_name
  cloud_run_service_name = module.api.cloud_run_service_name
  domain_name            = var.domain_name

  depends_on = [
    module.api,
    module.ui
  ]
}
