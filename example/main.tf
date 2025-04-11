# Deploys the environment landing zone module
module "lz" {
  source = "../"

  project     = var.project
  region      = var.region
  app_name    = var.app_name
  environment = var.environment

  docker_repository = var.docker_repository
  github_oidc       = var.github_oidc
  secrets           = var.secrets

  enable_monitoring           = var.enable_monitoring
  alert_notification_channels = var.alert_notification_channels
  log_alerts                  = var.log_alerts
  metric_alerts               = var.metric_alerts
}
