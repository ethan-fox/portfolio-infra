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

resource "google_project_service" "cloud_run" {
  project = var.project_id
  service = "run.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "secret_manager" {
  project = var.project_id
  service = "secretmanager.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "cloud_build" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"

  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "backend" {
  location      = var.region
  repository_id = "backend-images"
  description   = "Docker repository for backend API images"
  format        = "DOCKER"

  depends_on = [google_project_service.artifact_registry]
}

resource "google_secret_manager_secret" "database_url" {
  secret_id = "database-url"

  replication {
    auto {}
  }

  depends_on = [google_project_service.secret_manager]
}

resource "google_secret_manager_secret" "api_keys" {
  secret_id = "api-keys"

  replication {
    auto {}
  }

  depends_on = [google_project_service.secret_manager]
}

resource "google_service_account" "github_actions" {
  account_id   = "github-actions-deploy"
  display_name = "GitHub Actions Deployment Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "github_actions_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

module "cloud_run" {
  source = "./modules/cloud-run"

  project_id     = var.project_id
  region         = var.region
  service_name   = var.service_name
  image          = var.docker_image
  min_instances  = var.min_instances
  max_instances  = var.max_instances
  cors_origins   = var.cors_origins
  environment    = var.environment
  log_level      = var.log_level

  database_url_secret = google_secret_manager_secret.database_url.secret_id
  api_keys_secret     = google_secret_manager_secret.api_keys.secret_id

  depends_on = [
    google_project_service.cloud_run,
    google_secret_manager_secret.database_url,
    google_secret_manager_secret.api_keys
  ]
}
