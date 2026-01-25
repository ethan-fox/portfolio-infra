output "oauth_web_secret_name" {
  description = "Name of the web OAuth client ID secret in Secret Manager"
  value       = google_secret_manager_secret.oauth_web_client_id.secret_id
}

output "oauth_ios_secret_name" {
  description = "Name of the iOS OAuth client ID secret in Secret Manager"
  value       = google_secret_manager_secret.oauth_ios_client_id.secret_id
}
