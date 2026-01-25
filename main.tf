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

  google_oauth_client_id = var.google_oauth_client_id

  shop_with_mom_oauth_web_secret = module.shop_with_mom.oauth_web_secret_name
  shop_with_mom_oauth_ios_secret = module.shop_with_mom.oauth_ios_secret_name
}

# Shop-with-Mom OAuth Resources
module "shop_with_mom" {
  source = "./shop-with-mom"

  project_id          = var.project_id
  oauth_web_client_id = var.shop_with_mom_oauth_web_client_id
  oauth_ios_client_id = var.shop_with_mom_oauth_ios_client_id
}

# UI Frontend Resources (ethan-builds.com)
module "ui" {
  source = "./ui"

  project_id           = var.project_id
  region               = var.region
  frontend_bucket_name = var.frontend_bucket_name
  domain_name          = var.domain_name
}

# Three Beasts Frontend Resources (three-beasts.com)
module "three_beasts_web" {
  source = "./three-beasts-web"

  project_id           = var.project_id
  region               = var.region
  frontend_bucket_name = var.three_beasts_bucket_name
  domain_name          = var.three_beasts_domain_name
}

# Load Balancer Resources
module "load_balancer" {
  source = "./load-balancer"

  project_id                   = var.project_id
  region                       = var.region
  frontend_bucket_name         = module.ui.frontend_bucket_name
  domain_name                  = var.domain_name
  three_beasts_bucket_name     = module.three_beasts_web.frontend_bucket_name
  three_beasts_domain_name     = var.three_beasts_domain_name
  cloud_run_service_name       = module.api.cloud_run_service_name

  depends_on = [
    module.api,
    module.ui,
    module.three_beasts_web
  ]
}
