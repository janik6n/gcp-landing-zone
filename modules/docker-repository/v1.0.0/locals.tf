locals {
  repository_name        = "${var.app_name}-${var.environment}-repo"
  repository_description = "Artifact Registry repository for ${var.app_name} in ${var.environment}"

  required_apis = [
    "artifactregistry.googleapis.com"
  ]
}
