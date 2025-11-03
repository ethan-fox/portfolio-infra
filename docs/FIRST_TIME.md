# First time Setup

Retaining these steps for posterity, in case I ever need to do this again. Some things need to occur one-off before Terraform works correctly.

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
docker_image  = "gcr.io/cloudrun/placeholder" # Update based on image name

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

### 2. Create Service Account Key for GitHub Actions

This key allows GitHub Actions to deploy to Cloud Run:

1. Go to [IAM & Admin → Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
2. Find: `github-actions-deploy@your-project-id.iam.gserviceaccount.com`
3. Click the **Actions** menu (⋮) → **Manage Keys**
4. Click **Add Key** → **Create New Key**
5. Select **JSON** format
6. Click **Create** (downloads a JSON file)
7. **Save this file securely** - you'll add it to GitHub Secrets in your backend repo