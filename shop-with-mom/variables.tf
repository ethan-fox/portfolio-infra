variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "oauth_web_client_id" {
  description = "Google OAuth Client ID for web platform"
  type        = string
  sensitive   = true
}
