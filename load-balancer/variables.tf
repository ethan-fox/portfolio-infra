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
  description = "User-facing hostname for ethan-builds.com"
  type        = string
}

variable "three_beasts_bucket_name" {
  description = "Name of the Cloud Storage bucket for Three Beasts frontend"
  type        = string
}

variable "three_beasts_domain_name" {
  description = "User-facing hostname for three-beasts.com"
  type        = string
}