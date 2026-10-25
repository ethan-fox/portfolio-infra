# Without this, the module resolves to hashicorp/cloudflare and never receives
# the root provider's configuration.
terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}
