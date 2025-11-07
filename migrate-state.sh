#!/bin/bash
# State Migration Script
# Moves existing resources from root to module structure without destroying them

set -e  # Exit on any error

echo "=========================================="
echo "Terraform State Migration Script"
echo "=========================================="
echo ""
echo "This script will move existing resources into the new module structure."
echo "No resources will be destroyed - they will just be reorganized in state."
echo ""
read -p "Press ENTER to continue or CTRL+C to cancel..."
echo ""

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Moving Cloud Run module resources...${NC}"

# Move Cloud Run service
echo "Moving Cloud Run service..."
tofu state mv \
  'module.cloud_run.google_cloud_run_service.backend' \
  'module.api.module.cloud_run.google_cloud_run_service.backend'

# Move service account
echo "Moving Cloud Run service account..."
tofu state mv \
  'module.cloud_run.google_service_account.cloud_run' \
  'module.api.module.cloud_run.google_service_account.cloud_run'

# Move IAM binding for secret accessor
echo "Moving secret accessor IAM binding..."
tofu state mv \
  'module.cloud_run.google_project_iam_member.secret_accessor' \
  'module.api.module.cloud_run.google_project_iam_member.secret_accessor'

# Move public access IAM binding (will be removed later, but move it first)
echo "Moving public access IAM binding..."
tofu state mv \
  'module.cloud_run.google_cloud_run_service_iam_member.public_access' \
  'module.api.module.cloud_run.google_cloud_run_service_iam_member.public_access' || echo "Public access binding not found (may have been removed already)"

echo ""
echo -e "${YELLOW}Moving Secret Manager resources...${NC}"

# Move database URL secret
echo "Moving database-url secret..."
tofu state mv \
  'google_secret_manager_secret.database_url' \
  'module.api.google_secret_manager_secret.database_url'

# Move API key secret
echo "Moving api-key secret..."
tofu state mv \
  'google_secret_manager_secret.api_key' \
  'module.api.google_secret_manager_secret.api_key'

echo ""
echo -e "${YELLOW}Artifact Registry staying at root level (no move needed)${NC}"

echo ""
echo -e "${GREEN}=========================================="
echo "State migration completed successfully!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Run 'tofu plan' to verify no resources will be destroyed"
echo "2. You should see:"
echo "   - Existing resources being modified (Cloud Run ingress, IAM changes)"
echo "   - New resources being created (load balancer, storage bucket)"
echo "   - NO resources being destroyed"
echo "3. If the plan looks good, run 'tofu apply'"
echo ""
