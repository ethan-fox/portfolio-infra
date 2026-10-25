output "zone_id" {
  description = "Cloudflare zone ID for the powerhands domain"
  value       = data.cloudflare_zone.this.id
}

output "site_url" {
  description = "Public URL of the powerhands client"
  value       = "https://${var.domain_name}"
}

output "api_url" {
  description = "Public URL of the powerhands game server"
  value       = "https://${cloudflare_workers_custom_domain.api.hostname}"
}
