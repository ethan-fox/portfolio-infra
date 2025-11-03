# Artifact Registry
# Docker image repository for application containers

resource "google_artifact_registry_repository" "backend" {
  location      = var.region
  repository_id = "portfolio-images"
  description   = "Docker repository for portfolio application images"
  format        = "DOCKER"

  depends_on = [google_project_service.artifact_registry]
}
