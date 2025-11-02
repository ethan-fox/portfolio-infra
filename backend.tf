terraform {
  backend "gcs" {
    bucket = "portfolio-terraform-state-072496"
    prefix = "terraform/state"
  }
}
