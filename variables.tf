variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "backend-api"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "docker_image" {
  description = "Docker image URL for the backend (will be updated by CI/CD)"
  type        = string
  default     = "gcr.io/cloudrun/placeholder"
}

variable "min_instances" {
  description = "Minimum number of Cloud Run instances (0 for scale-to-zero)"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of Cloud Run instances"
  type        = number
  default     = 20
}

variable "log_level" {
  description = "Application log level (DEBUG, INFO, WARNING, ERROR)"
  type        = string
  default     = "INFO"
}

variable "frontend_bucket_name" {
  description = "Name for the Cloud Storage bucket hosting frontend files"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application (e.g., ethan-builds.com)"
  type        = string
}

variable "google_oauth_client_id" {
  description = "Google OAuth Client ID (for backend token validation)"
  type        = string
  sensitive   = true
}
