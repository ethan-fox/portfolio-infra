variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for regional resources"
  type        = string
}

variable "frontend_bucket_name" {
  description = "Name of the Cloud Storage bucket for frontend"
  type        = string
}

variable "cloud_run_service_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "domain_name" {
  description = "User-facing hostname for the Load balancer"
type = string
}