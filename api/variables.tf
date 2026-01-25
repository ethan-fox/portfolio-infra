variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "docker_image" {
  description = "Docker image URL for the backend"
  type        = string
}

variable "min_instances" {
  description = "Minimum number of Cloud Run instances (0 for scale-to-zero)"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of Cloud Run instances"
  type        = number
}

variable "log_level" {
  description = "Application log level (DEBUG, INFO, WARNING, ERROR)"
  type        = string
}

variable "shop_with_mom_oauth_web_secret" {
  description = "Secret Manager secret name for shop-with-mom web OAuth client ID"
  type        = string
  default     = ""
}

variable "shop_with_mom_jwt_secret" {
  description = "Secret Manager secret name for shop-with-mom JWT secret"
  type        = string
  default     = ""
}
