terraform {
  required_version = "~> 1.9"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.27"
    }
  }
  backend "gcs" {
    bucket = "my-bucket-name"
    prefix = "sample-project-lz-dev"
  }
}

# Provider configuration for GCP
provider "google" {
  project = var.project
  region  = var.region
}
