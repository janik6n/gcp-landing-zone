locals {
  sa_name        = "github-actions-${var.environment}-sa"
  sa_description = "GitHub Actions Service Account for ${var.environment} environment"

  identity_pool_id                   = "github-actions-${var.environment}-id-pool"
  identity_pool_description          = "GitHub Actions Identity Pool for ${var.environment} environment"
  identity_pool_provider_id          = "gha-${var.environment}-id-pool-provider"
  identity_pool_provider_description = "GitHub Actions Identity Pool Provider for ${var.environment} environment"

  # required_apis = [
  #   "run.googleapis.com",
  # ]
}
