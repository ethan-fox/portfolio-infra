# DNS-only (not proxied): Google-managed certs provision only when the hostname
# resolves directly to the load balancer IP.
resource "cloudflare_dns_record" "apex" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.domain_name
  type    = "A"
  content = var.frontend_lb_ip
  ttl     = 300
  proxied = false
}

resource "cloudflare_dns_record" "www" {
  zone_id = data.cloudflare_zone.this.id
  name    = "www.${var.domain_name}"
  type    = "A"
  content = var.frontend_lb_ip
  ttl     = 300
  proxied = false
}
