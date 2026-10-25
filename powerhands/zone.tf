# Cloudflare Registrar created the zone, so it is read here rather than managed.
data "cloudflare_zone" "this" {
  filter = {
    name = var.domain_name
  }
}
