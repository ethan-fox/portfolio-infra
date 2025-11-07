# GCP Project Configuration
project_id = "portfolio-477017"
region     = "us-central1"

# Cloud Run Configuration
service_name  = "portfolio-api"
environment   = "PROD"
docker_image  = "us-central1-docker.pkg.dev/portfolio-477017/portfolio-images/portfolio-api:latest"

# Scaling Configuration
min_instances = 0   # 0 = scale-to-zero (cost savings), 1 = always-warm
max_instances = 20  # Cost protection limit

# Application Configuration
log_level    = "INFO"  # DEBUG, INFO, WARNING, ERROR

# Frontend Configuration
frontend_bucket_name = "portfolio-ui-frontend"
domain_name          = "ethan-builds.com"
