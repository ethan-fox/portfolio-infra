output "oauth_web_secret_name" {
  description = "Name of the web OAuth client ID secret in Secret Manager"
  value       = google_secret_manager_secret.oauth_web_client_id.secret_id
}

output "jwt_secret_name" {
  description = "Name of the JWT secret in Secret Manager"
  value       = google_secret_manager_secret.jwt_secret.secret_id
}
