data "google_project" "this" {
  project_id = var.project
}

# Enable required APIs
resource "google_project_service" "this" {
  for_each = toset(local.required_apis)
  project  = var.project
  service  = each.value

  disable_on_destroy = false
}

# Create GitHub OIDC Configuration
module "mod_github_oidc" {
  source = "./modules/github-oidc/v1.0.0"
  count  = var.github_oidc.create_github_oidc_configuration ? 1 : 0

  project                                  = var.project
  environment                              = var.environment
  workload_identity_pool_disabled          = var.github_oidc.workload_identity_pool_disabled
  workload_identity_pool_provider_disabled = var.github_oidc.workload_identity_pool_provider_disabled
  github_org                               = var.github_oidc.github_org
  allowed_repositories                     = var.github_oidc.allowed_repositories
  allowed_roles                            = var.github_oidc.allowed_roles
}

# Create Docker Registry Repository in Artifact Registry
module "mod_docker_repository" {
  source = "./modules/docker-repository/v1.0.0"
  count  = var.docker_repository.create_docker_repository ? 1 : 0

  project                = var.project
  region                 = var.region
  app_name               = var.app_name
  environment            = var.environment
  versions_to_keep       = var.docker_repository.versions_to_keep
  delete_older_than      = var.docker_repository.delete_older_than
  cleanup_dryrun         = var.docker_repository.cleanup_dryrun
  vulnerability_scanning = var.docker_repository.vulnerability_scanning
}

# Create Secrets. Secrets versions will be created later without TF."
module "mod_secrets" {
  source   = "./modules/secret/v1.0.0"
  for_each = var.secrets

  project     = var.project
  region      = var.region
  app_name    = var.app_name
  environment = var.environment
  secret_name = each.value
}

module "mod_monitoring" {
  source = "./modules/monitoring/v1.0.0"
  count  = var.enable_monitoring ? 1 : 0

  project                     = var.project
  region                      = var.region
  app_name                    = var.app_name
  environment                 = var.environment
  alert_notification_channels = var.alert_notification_channels
  log_alerts                  = var.log_alerts
  metric_alerts               = var.metric_alerts
}
