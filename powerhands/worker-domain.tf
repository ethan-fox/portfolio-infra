# Game server Worker. The script itself is deployed by the powerhands repo's CI
# (wrangler), so it must exist before this is applied.
resource "cloudflare_workers_custom_domain" "api" {
  account_id = data.cloudflare_zone.this.account.id
  zone_id    = data.cloudflare_zone.this.id
  hostname   = "api.${var.domain_name}"
  service    = "powerhands"
}
