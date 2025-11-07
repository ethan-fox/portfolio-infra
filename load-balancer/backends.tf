# Backend configurations for load balancer

# Network Endpoint Group for Cloud Run backend
resource "google_compute_region_network_endpoint_group" "backend_neg" {
  name                  = "backend-api-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = var.cloud_run_service_name
  }
}

# Backend bucket for frontend (Cloud Storage)
resource "google_compute_backend_bucket" "frontend" {
  name        = "frontend-backend-bucket"
  bucket_name = var.frontend_bucket_name
  enable_cdn  = true

  cdn_policy {
    cache_mode       = "CACHE_ALL_STATIC"
    default_ttl      = 3600
    max_ttl          = 86400
    client_ttl       = 3600
    negative_caching = true
  }
}

# Backend service for API (Cloud Run)
resource "google_compute_backend_service" "backend_api" {
  name        = "backend-api-service"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 60
  enable_cdn  = false

  backend {
    group = google_compute_region_network_endpoint_group.backend_neg.id
  }

  log_config {
    enable      = true
    sample_rate = 1.0
  }
}
