resource "google_secret_manager_secret" "oauth_web_client_id" {
  secret_id = "shop-with-mom-oauth-web-client-id"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "oauth_web_client_id" {
  secret      = google_secret_manager_secret.oauth_web_client_id.id
  secret_data = var.oauth_web_client_id
}

resource "google_secret_manager_secret" "oauth_ios_client_id" {
  secret_id = "shop-with-mom-oauth-ios-client-id"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "oauth_ios_client_id" {
  secret      = google_secret_manager_secret.oauth_ios_client_id.id
  secret_data = var.oauth_ios_client_id
}
