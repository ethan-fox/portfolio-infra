# Portfolio Infrastructure 

Terraform configurations which specify the full-stack topography of the `portfolio` app.

## Prerequisites

These pre-reqs are **optional**, but your local Devex may be degraded.

- [gcloud CLI](https://cloud.google.com/sdk/docs/install) installed and authenticated
- [OpenTofu](https://opentofu.org/docs/intro/install/) >= 1.6 installed (open source Terraform alternative)

## Making Infrastructure Changes

### Update Configuration

E.g. edit `terraform.tfvars`:

```hcl
# Example: Change to always-warm configuration
min_instances = 1  # Changed from 0

# Example: Update CORS origins
cors_origins = "http://localhost:3000,https://prod.yourdomain.com"
```

(Or, any `module` changes)

### Apply Changes

Functionally, assuming proper permissions, we could simply `plan` and `apply` from bare metal:

```bash
tofu plan   # Preview changes
tofu apply  # Apply changes
```

However, this is prone to error and not scalable for an Engineering group. Our CI pipeline gates `Apply` behind a permissioned workflow:

```bash
# <Make changes>
git add .
git commit -m "Made some changes"
git push origin master  # Or, merge from PR

git tag X.Y.Z  # IMPORTANT, tag must follow semver to trigger CI
git push origin X.Y.Z
```

This will trigger a Github Actions workflow, which you can view in the `Actions` tab. From there, based on the `Plan` you can decide whether or not to move forward with `Apply`.

## Cloudflare (powerhands.net)

`powerhands.net` is registered with Cloudflare Registrar, so its zone lives in Cloudflare and is read via a data source, not managed. The `powerhands/` module manages its DNS records (pointing at the frontend load balancer) and the `api.powerhands.net` custom domain for the game server Worker. The Worker script is deployed by the powerhands repo's CI, and must exist before this module is first applied.

The provider authenticates with the `CLOUDFLARE_API_TOKEN` repo secret, passed to OpenTofu as `TF_VAR_cloudflare_api_token`. Token permissions:

- Zone / Zone / Read, Zone / DNS / Edit, and Zone / Workers Routes / Edit, scoped to `powerhands.net`
- Account / Workers Scripts / Edit

To plan locally: `export TF_VAR_cloudflare_api_token=...` before `tofu plan`.

## Reference Material

* [Appendix](./docs/APPENDIX.md)
* [First-time Setup](./docs/FIRST_TIME.md)