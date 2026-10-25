# Portfolio Infrastructure - Main Configuration
# OpenTofu version and provider configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
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

  shop_with_mom_oauth_web_secret = module.shop_with_mom.oauth_web_secret_name
  shop_with_mom_jwt_secret       = module.shop_with_mom.jwt_secret_name
}

# Shop-with-Mom Resources
module "shop_with_mom" {
  source = "./shop-with-mom"

  project_id          = var.project_id
  oauth_web_client_id = var.shop_with_mom_oauth_web_client_id
  jwt_secret          = var.shop_with_mom_jwt_secret
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

# Powerhands Frontend Resources (powerhands.net)
module "powerhands_web" {
  source = "./powerhands-web"

  project_id           = var.project_id
  region               = var.region
  frontend_bucket_name = var.powerhands_bucket_name
  domain_name          = var.powerhands_domain_name
}

# Powerhands DNS and game server domain (Cloudflare)
module "powerhands" {
  source = "./powerhands"

  domain_name    = var.powerhands_domain_name
  frontend_lb_ip = module.load_balancer.frontend_load_balancer_ip
}

# Load Balancer Resources
module "load_balancer" {
  source = "./load-balancer"

  project_id               = var.project_id
  region                   = var.region
  frontend_bucket_name     = module.ui.frontend_bucket_name
  domain_name              = var.domain_name
  three_beasts_bucket_name = module.three_beasts_web.frontend_bucket_name
  three_beasts_domain_name = var.three_beasts_domain_name
  powerhands_bucket_name   = module.powerhands_web.frontend_bucket_name
  powerhands_domain_name   = var.powerhands_domain_name
  cloud_run_service_name   = module.api.cloud_run_service_name

  depends_on = [
    module.api,
    module.ui,
    module.three_beasts_web,
    module.powerhands_web
  ]
}
