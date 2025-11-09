# Global HTTP(S) Load Balancer
# Routes traffic to frontend (Cloud Storage) and backend (Cloud Run)

# Reserve static IP addresses
resource "google_compute_global_address" "frontend" {
  name = "frontend-lb-ip"
}

resource "google_compute_global_address" "backend" {
  name = "backend-lb-ip"
}

# URL map for frontend
resource "google_compute_url_map" "frontend" {
  name            = "frontend-url-map"
  default_service = google_compute_backend_bucket.frontend.id
}

# URL map for backend
resource "google_compute_url_map" "backend" {
  name            = "backend-url-map"
  default_service = google_compute_backend_service.backend_api.id
}

# Managed SSL certificates
resource "google_compute_managed_ssl_certificate" "frontend" {
  name = "frontend-ssl-cert"

  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_managed_ssl_certificate" "backend" {
  name = "backend-ssl-cert"

  managed {
    domains = ["api.${var.domain_name}"]
  }
}

# HTTP proxy for frontend
resource "google_compute_target_http_proxy" "frontend" {
  name    = "frontend-http-proxy"
  url_map = google_compute_url_map.frontend.id
}

# HTTPS proxy for frontend
resource "google_compute_target_https_proxy" "frontend" {
  name             = "frontend-https-proxy"
  url_map          = google_compute_url_map.frontend.id
  ssl_certificates = [google_compute_managed_ssl_certificate.frontend.id]
}

# HTTP proxy for backend
resource "google_compute_target_http_proxy" "backend" {
  name    = "backend-http-proxy"
  url_map = google_compute_url_map.backend.id
}

# HTTPS proxy for backend
resource "google_compute_target_https_proxy" "backend" {
  name             = "backend-https-proxy"
  url_map          = google_compute_url_map.backend.id
  ssl_certificates = [google_compute_managed_ssl_certificate.backend.id]
}

# Forwarding rules for frontend
resource "google_compute_global_forwarding_rule" "frontend_http" {
  name       = "frontend-http-forwarding-rule"
  target     = google_compute_target_http_proxy.frontend.id
  port_range = "80"
  ip_address = google_compute_global_address.frontend.address
}

resource "google_compute_global_forwarding_rule" "frontend_https_v2" {
  name       = "frontend-https-forwarding-rule-v2"
  target     = google_compute_target_https_proxy.frontend.id
  port_range = "443"
  ip_address = google_compute_global_address.frontend.address
}

# Forwarding rules for backend
resource "google_compute_global_forwarding_rule" "backend_http" {
  name       = "backend-http-forwarding-rule"
  target     = google_compute_target_http_proxy.backend.id
  port_range = "80"
  ip_address = google_compute_global_address.backend.address
}

resource "google_compute_global_forwarding_rule" "backend_https_v2" {
  name       = "backend-https-forwarding-rule-v2"
  target     = google_compute_target_https_proxy.backend.id
  port_range = "443"
  ip_address = google_compute_global_address.backend.address
}
