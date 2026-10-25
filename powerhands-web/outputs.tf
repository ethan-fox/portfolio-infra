output "frontend_bucket_name" {
  description = "Name of the Cloud Storage bucket for frontend files"
  value       = google_storage_bucket.frontend.name
}

output "frontend_bucket_url" {
  description = "URL of the frontend bucket"
  value       = google_storage_bucket.frontend.url
}
