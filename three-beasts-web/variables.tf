variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "frontend_bucket_name" {
  description = "Name for the Cloud Storage bucket hosting frontend files"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}
