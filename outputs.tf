output "project_name" {
  description = "Project name"
  value       = var.project
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "github_oidc_details" {
  description = "GitHub OIDC configuration details (only shown if OIDC was configured)"
  value = var.github_oidc.create_github_oidc_configuration ? {
    project                         = var.project
    workload_identity_pool_provider = module.mod_github_oidc[0].workload_identity_pool_provider_name
    service_account_email           = module.mod_github_oidc[0].service_account_email
    github_org                      = var.github_oidc.github_org
    allowed_repositories            = var.github_oidc.allowed_repositories
    setup_instructions              = <<-EOT
      Configure these GitHub Actions secrets:

      GCP_WORKLOAD_IDENTITY_PROVIDER: ${module.mod_github_oidc[0].workload_identity_pool_provider_name}
      GCP_SA_EMAIL: ${module.mod_github_oidc[0].service_account_email}

      Configured for GitHub Organization: ${var.github_oidc.github_org}

      Allowed Repositories:
      - ${join("\n      - ", var.github_oidc.allowed_repositories)}

      Note: Wait 5-10 minutes after creation before trying to obtain tokens!
    EOT
  } : null
}

output "docker_repository" {
  description = "Artifact Registry Docker repository (only shown if repository was created)"
  value = var.docker_repository.create_docker_repository ? {
    name = module.mod_docker_repository[0].repository_name
    uri  = module.mod_docker_repository[0].repository_uri
  } : null
}

output "secret_ids" {
  description = "List of secret IDs created (only shown if secrets were created)"
  value = var.secrets != {} ? {
    for name, secret in module.mod_secrets : name => secret.secret_id
  } : null
}

output "monitoring_notification_channels" {
  description = "Monitoring notification channels (only shown if channels were configured)"
  value = var.alert_notification_channels != {} ? {
    for name, channel in module.mod_monitoring[0].notification_channels : name => {
      name    = channel.name
      type    = channel.type
      address = channel.address
    }
  } : null
}

output "monitoring_log_alerts" {
  description = "Monitoring configuration details for log alerts (only shown if alerts were configured)"
  value = var.log_alerts != {} ? {
    for name, alert in module.mod_monitoring[0].log_alerts : name => {
      name     = alert.name
      severity = alert.severity
      # conditions     = alert.conditions
      # alert_strategy = alert.alert_strategy
    }
  } : null
}

output "monitoring_metric_alerts" {
  description = "Monitoring configuration details for metric alerts (only shown if alerts were configured)"
  value = var.metric_alerts != {} ? {
    for name, alert in module.mod_monitoring[0].metric_alerts : name => {
      name     = alert.name
      severity = alert.severity
      # conditions     = alert.conditions
      # alert_strategy = alert.alert_strategy
    }
  } : null
}
