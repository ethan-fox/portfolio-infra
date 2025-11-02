# Portfolio Infrastructure 

OpenTofu infrastructure for deploying a full-stack application to Google Cloud Run with scale-to-zero capabilities, Secret Manager integration, and GitHub Actions CI/CD support.

## Architecture

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

## Prerequisites

- GCP account with billing enabled
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) installed and authenticated
- [OpenTofu](https://opentofu.org/docs/intro/install/) >= 1.6 installed (open source Terraform alternative)
- Existing GCP project

## Initial Setup

### 1. Authenticate with GCP

```bash
gcloud auth login
gcloud auth application-default login
```

### 2. Create GCS Bucket for OpenTofu State (via Console)

1. Go to [Google Cloud Console → Cloud Storage](https://console.cloud.google.com/storage/browser)
2. Click **Create Bucket**
3. **Name**: `your-project-id-terraform-state` (must be globally unique)
4. **Location**: Choose same region as your resources (e.g., `us-central1`)
5. **Storage Class**: Standard
6. **Access Control**: Uniform
7. Click **Create**

### 3. Configure OpenTofu Backend

Edit `backend.tf` and replace the bucket name:

```hcl
terraform {
  backend "gcs" {
    bucket = "your-project-id-terraform-state"  # Replace with your bucket name
    prefix = "terraform/state"
  }
}
```

### 4. Create terraform.tfvars

Copy the example and customize:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```hcl
project_id = "your-gcp-project-id"
region     = "us-central1"

service_name  = "backend-api"
environment   = "dev"
docker_image  = "gcr.io/cloudrun/placeholder"

min_instances = 0   # Scale-to-zero for cost savings
max_instances = 20

cors_origins = "http://localhost:3000,https://yourdomain.com"
log_level    = "INFO"
```

### 5. Initialize and Apply OpenTofu

```bash
# Initialize OpenTofu (downloads providers, configures backend)
tofu init

# Preview what will be created
tofu plan

# Create infrastructure
tofu apply
```

Type `yes` when prompted. This will create all infrastructure (~2-3 minutes).

**Note**: OpenTofu uses the `tofu` command instead of `terraform`. All other syntax is identical.

## Post-Deployment Configuration

After `tofu apply` completes successfully, complete these steps to make your backend fully operational.

### 1. Populate Secrets in Secret Manager

Your infrastructure created empty secrets. Now add the actual values:

**DATABASE_URL Secret:**
1. Go to [Secret Manager](https://console.cloud.google.com/security/secret-manager)
2. Find the secret named `database-url`
3. Click on it → **New Version**
4. Paste your database connection string (e.g., `postgresql://user:pass@host:5432/dbname`)
5. Click **Add New Version**

**API_KEYS Secret:**
1. Find the secret named `api-keys`
2. Click on it → **New Version**
3. Paste comma-separated API keys (e.g., `key1,key2,key3`)
4. Click **Add New Version**

### 2. Create Service Account Key for GitHub Actions

This key allows GitHub Actions to deploy to Cloud Run:

1. Go to [IAM & Admin → Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
2. Find: `github-actions-deploy@your-project-id.iam.gserviceaccount.com`
3. Click the **Actions** menu (⋮) → **Manage Keys**
4. Click **Add Key** → **Create New Key**
5. Select **JSON** format
6. Click **Create** (downloads a JSON file)
7. **Save this file securely** - you'll add it to GitHub Secrets in your backend repo

### 3. Note Your OpenTofu Outputs

Get the values you'll need for GitHub Actions setup:

```bash
tofu output
```

You'll need these outputs:
- `cloud_run_url` - Your deployed API endpoint
- `artifact_registry_location` - Where to push Docker images
- `github_actions_service_account` - Service account email (for reference)
- `database_url_secret_name` - Verify it's `database-url`
- `api_keys_secret_name` - Verify it's `api-keys`

### 4. Set Up GitHub Actions in Your Backend Repo

See `BACKEND_SETUP.md` for complete instructions on configuring GitHub Actions in your backend repository.

## Making Infrastructure Changes

### Update Configuration

Edit `terraform.tfvars`:

```hcl
# Example: Change to always-warm configuration
min_instances = 1  # Changed from 0

# Example: Update CORS origins
cors_origins = "http://localhost:3000,https://prod.yourdomain.com"
```

### Apply Changes

```bash
tofu plan   # Preview changes
tofu apply  # Apply changes
```

### Update Secrets

Secrets can be updated anytime via Console:
1. Go to [Secret Manager](https://console.cloud.google.com/security/secret-manager)
2. Click on the secret
3. Add a new version (Cloud Run picks up changes automatically)

## Testing the Deployment

### Test Cloud Run Endpoint

```bash
# Get the URL from OpenTofu output
CLOUD_RUN_URL=$(tofu output -raw cloud_run_url)

# Test health check endpoint
curl $CLOUD_RUN_URL/health

# Expected response: {"status": "healthy"}
```

### Manual Docker Push (Optional)

For testing before setting up GitHub Actions:

```bash
# Authenticate Docker with GCP
gcloud auth configure-docker us-central1-docker.pkg.dev

# Get registry location
REGISTRY=$(tofu output -raw artifact_registry_location)

# Tag and push your image
docker tag your-backend:latest $REGISTRY/backend:test
docker push $REGISTRY/backend:test

# Deploy manually
gcloud run deploy backend-api \
  --image=$REGISTRY/backend:test \
  --region=us-central1
```

## Cost Optimization

### Scale-to-Zero (Default - Free Tier Target)

```hcl
# terraform.tfvars
min_instances = 0
```

**Tradeoffs:**
- ✅ Likely stays in free tier ($0/month)
- ✅ Only pay when API receives traffic
- ❌ Cold start latency (~1-2 seconds on first request)

### Always-Warm Configuration

```hcl
# terraform.tfvars
min_instances = 1
```

**Tradeoffs:**
- ✅ No cold starts (instant response)
- ❌ ~$10/month cost for always-on instance

### Monitor Costs

Set up budget alerts in Console:
1. Go to [Billing → Budgets & Alerts](https://console.cloud.google.com/billing/budgets)
2. Click **Create Budget**
3. Set budget amount (e.g., $25/month)
4. Set threshold alerts (50%, 90%, 100%)
5. Add your email

## Monitoring & Logging

### View Metrics (Console)

1. Go to [Cloud Run](https://console.cloud.google.com/run)
2. Click on `backend-api` service
3. **Metrics** tab shows:
   - Request count, latency
   - Instance count
   - Memory/CPU usage

### View Logs (Console)

1. In Cloud Run service page → **Logs** tab
2. Or use [Logs Explorer](https://console.cloud.google.com/logs)
3. Filter:
   ```
   resource.type="cloud_run_revision"
   resource.labels.service_name="backend-api"
   ```

### View Logs (CLI)

```bash
# Tail logs in real-time
gcloud run services logs tail backend-api --region=us-central1

# Recent logs
gcloud run services logs read backend-api --region=us-central1 --limit=100

# Filter errors
gcloud run services logs read backend-api --region=us-central1 | grep ERROR
```

## Troubleshooting

### OpenTofu Init Fails

**Error**: "Failed to get existing workspaces"

**Check**:
- GCS bucket exists: `gsutil ls gs://your-bucket-name`
- Bucket name in `backend.tf` matches
- You have bucket access permissions

### Cloud Run Service Won't Start

**Symptoms**: Service exists but shows errors

**Common causes**:
1. **Health check failing** - FastAPI must respond to `GET /health` on port 8000
2. **Secrets not populated** - Check Secret Manager has versions added
3. **Wrong port** - Ensure FastAPI listens on port 8000

**Debug**:
```bash
# Check logs for startup errors
gcloud run services logs read backend-api --limit=50

# Verify secrets have versions
gcloud secrets versions list database-url
gcloud secrets versions list api-keys
```

### Permission Denied

**Error**: "Permission denied on resource project"

**Fix**:
```bash
# Re-authenticate
gcloud auth application-default login

# Set correct project
gcloud config set project your-project-id

# Verify
gcloud config get-value project
```

### Artifact Registry Push Fails

**Error**: "unauthorized: You don't have the needed permissions"

**Fix**:
```bash
# Configure Docker auth
gcloud auth configure-docker us-central1-docker.pkg.dev

# Verify registry exists
gcloud artifacts repositories list --location=us-central1
```

## Cleanup

**⚠️ Warning**: This destroys all resources (except state bucket).

```bash
# Preview destruction
tofu plan -destroy

# Destroy infrastructure
tofu destroy
```

Type `yes` when prompted.

**Manual cleanup** (if needed):
```bash
# Delete state bucket (not managed by OpenTofu)
gsutil rm -r gs://your-project-id-terraform-state
```

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

## Resources

- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [OpenTofu Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Secret Manager](https://cloud.google.com/secret-manager/docs)
- [Artifact Registry](https://cloud.google.com/artifact-registry/docs)
- [FastAPI](https://fastapi.tiangolo.com/)
