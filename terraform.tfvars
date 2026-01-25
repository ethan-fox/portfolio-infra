# GCP Project Configuration
project_id = "portfolio-477017"
region     = "us-central1"

# Cloud Run Configuration
service_name = "portfolio-api"
environment  = "PROD"
docker_image = "us-central1-docker.pkg.dev/portfolio-477017/portfolio-images/portfolio-api:latest"

# Scaling Configuration
min_instances = 1  # 0 = scale-to-zero (cost savings), 1 = always-warm
max_instances = 20 # Cost protection limit

# Application Configuration
log_level = "INFO" # DEBUG, INFO, WARNING, ERROR

# Google OAuth Client ID (portfolio)
google_oauth_client_id = "720950635621-0mjjfceh5nnda6sck0s8hq2cufl32h0e.apps.googleusercontent.com"

# Frontend Configuration (ethan-builds.com)
frontend_bucket_name = "portfolio-ui-frontend"
domain_name          = "ethan-builds.com"

# Three Beasts Frontend Configuration (three-beasts.com)
three_beasts_bucket_name = "three-beasts-web-frontend"
three_beasts_domain_name = "three-beasts.com"

# Shop with Mom Client IDs
shop_with_mom_oauth_web_client_id = "720950635621-m14nssm5oo38q0lfcbanc8cn6vsk79lm.apps.googleusercontent.com"
shop_with_mom_oauth_ios_client_id = "720950635621-tsladdcm9in4g6vr9k0kfs5akv2h1336.apps.googleusercontent.com"
