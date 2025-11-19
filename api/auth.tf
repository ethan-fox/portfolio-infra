resource "google_secret_manager_secret_iam_member" "api_oauth_client_id_access" {
  secret_id = google_secret_manager_secret.oauth_client_id.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${module.cloud_run.service_account_email}"
}
