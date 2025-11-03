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

git tag X.Y.Z
git push origin X.Y.Z
```

## Reference Material

* [Appendix](./docs/APPENDIX.md)
* [First-time Setup](./docs/FIRST_TIME.md)