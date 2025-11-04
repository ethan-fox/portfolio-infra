resource "google_service_account" "cloud_run" {
  account_id   = "${var.service_name}-sa"
  display_name = "Service Account for ${var.service_name} Cloud Run"
  project      = var.project_id
}

resource "google_project_iam_member" "secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_cloud_run_service" "backend" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      service_account_name = google_service_account.cloud_run.email

      containers {
        image = var.image

        resources {
          limits = {
            cpu    = var.cpu
            memory = var.memory
          }
        }

        env {
          name  = "ENVIRONMENT"
          value = var.environment
        }

        env {
          name  = "LOG_LEVEL"
          value = var.log_level
        }

        env {
          name  = "CORS_ORIGINS"
          value = var.cors_origins
        }

        env {
          name = "DATABASE_URL"
          value_from {
            secret_key_ref {
              name = var.database_url_secret
              key  = "latest"
            }
          }
        }

        env {
          name = "API_KEY"
          value_from {
            secret_key_ref {
              name = var.api_key_secret
              key  = "latest"
            }
          }
        }

        ports {
          container_port = 7050
        }

        startup_probe {
          http_get {
            path = "/health"
            port = 7050
          }
          initial_delay_seconds = 15
          timeout_seconds       = 3
          period_seconds        = 5
          failure_threshold     = 3
        }

        liveness_probe {
          http_get {
            path = "/health"
            port = 7050
          }
          initial_delay_seconds = 0
          timeout_seconds       = 1
          period_seconds        = 10
          failure_threshold     = 3
        }
      }

      container_concurrency = var.concurrency
      timeout_seconds       = var.timeout_seconds
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = var.min_instances
        "autoscaling.knative.dev/maxScale" = var.max_instances
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.backend.name
  location = google_cloud_run_service.backend.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
