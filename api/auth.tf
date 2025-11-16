resource "google_identity_platform_config" "default" {
  project = var.project_id

  autodelete_anonymous_users = true

  sign_in {
    allow_duplicate_emails = false

    email {
      enabled           = true
      password_required = false
    }
  }

  authorized_domains = var.authorized_domains
}

resource "google_identity_platform_default_supported_idp_config" "google" {
  project = var.project_id
  idp_id  = "google.com"
  enabled = true

  client_id     = var.google_oauth_client_id
  client_secret = var.google_oauth_client_secret

  depends_on = [google_identity_platform_config.default]
}

resource "google_secret_manager_secret_iam_member" "api_oauth_client_id_access" {
  secret_id = google_secret_manager_secret.oauth_client_id.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${module.cloud_run.service_account_email}"
}

resource "google_secret_manager_secret_iam_member" "api_oauth_client_secret_access" {
  secret_id = google_secret_manager_secret.oauth_client_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${module.cloud_run.service_account_email}"
}
