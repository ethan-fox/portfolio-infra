
# Appendix

## Infra Architecture

```
Backend Repo (separate)
├── Git Tag (v1.0.0)
    ↓
GitHub Actions
├── Build Docker image
├── Push to Artifact Registry
└── Deploy to Cloud Run
    ↓
Cloud Run Service
├── FastAPI application
├── Auto-scaling (0-20 instances)
├── Secrets from Secret Manager
└── Public HTTPS endpoint
```

## Cost Estimate

| Component | Monthly Cost | Notes |
|-----------|--------------|-------|
| Cloud Run | $0 - $10 | Free tier: 2M requests/month. Scale-to-zero = $0 when idle |
| Artifact Registry | ~$0.10 | $0.10/GB storage for Docker images |
| Secret Manager | ~$0.18 | $0.06 per secret version (3 secrets) |
| Cloud Build | $0 | 120 build-minutes/day free tier |
| **Total** | **$0 - $11/month** | Likely $0 on free tier for hobby projects |

## Future Enhancements

Potential additions to this infrastructure:

- **Cloud Armor**: DDoS protection and rate limiting
- **Cloud Load Balancer**: Custom domains, SSL certificates
- **Multiple Environments**: OpenTofu workspaces for dev/staging/prod
- **Cloud SQL**: Migrate from external database to GCP-managed PostgreSQL
- **VPC Connector**: Private networking for secure database access
- **GitHub Actions for Infrastructure**: Automate `tofu apply` on changes
- **Monitoring Alerts**: Cloud Monitoring for error rates, latency

## Project Structure

```
portfolio-infra/
├── README.md                 # This file
├── BACKEND_SETUP.md          # GitHub Actions setup for backend repo
├── CLAUDE.md                 # Architecture decisions document
├── main.tf                   # Root module configuration
├── variables.tf              # Input variable definitions
├── outputs.tf                # Output values
├── backend.tf                # Remote state configuration
├── terraform.tfvars.example  # Template for configuration
├── terraform.tfvars          # Your actual values (gitignored)
├── .gitignore               # Terraform ignore rules
└── modules/
    └── cloud-run/
        ├── main.tf           # Cloud Run service, secrets, IAM
        ├── variables.tf      # Module input variables
        └── outputs.tf        # Module outputs
```