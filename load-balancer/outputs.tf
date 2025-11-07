output "frontend_load_balancer_ip" {
  description = "Static IP address for frontend load balancer (ethan-builds.com)"
  value       = google_compute_global_address.frontend.address
}

output "backend_load_balancer_ip" {
  description = "Static IP address for backend load balancer (api.ethan-builds.com)"
  value       = google_compute_global_address.backend.address
}

output "frontend_url_map_name" {
  description = "Name of the frontend URL map (for CDN cache invalidation)"
  value       = google_compute_url_map.frontend.name
}

output "backend_url_map_name" {
  description = "Name of the backend URL map"
  value       = google_compute_url_map.backend.name
}
