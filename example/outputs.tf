output "monitoring_notification_channels" {
  description = "Monitoring notification channels (only shown if channels were configured)"
  value = var.alert_notification_channels != {} ? {
    for name, channel in module.lz.monitoring_notification_channels : name => {
      name    = channel.name
      type    = channel.type
      address = channel.address
    }
  } : null
}

output "monitoring_log_alerts" {
  description = "Monitoring configuration details for log alerts (only shown if alerts were configured)"
  value = var.log_alerts != {} ? {
    for name, alert in module.lz.monitoring_log_alerts : name => {
      name     = alert.name
      severity = alert.severity
    }
  } : null
}

output "monitoring_metric_alerts" {
  description = "Monitoring configuration details for metric alerts (only shown if alerts were configured)"
  value = var.metric_alerts != {} ? {
    for name, alert in module.lz.monitoring_metric_alerts : name => {
      name     = alert.name
      severity = alert.severity
    }
  } : null
}

output "github_oidc_details" {
  description = "GitHub OIDC configuration details (only shown if OIDC was configured)"
  value = var.github_oidc.create_github_oidc_configuration ? {
    project                         = module.lz.github_oidc_details.project
    workload_identity_pool_provider = module.lz.github_oidc_details.workload_identity_pool_provider
    service_account_email           = module.lz.github_oidc_details.service_account_email
    github_org                      = module.lz.github_oidc_details.github_org
    allowed_repositories            = module.lz.github_oidc_details.allowed_repositories
    setup_instructions              = <<-EOT
      Configure these GitHub Actions secrets:

      GCP_WORKLOAD_IDENTITY_PROVIDER: ${module.lz.github_oidc_details.workload_identity_pool_provider}
      GCP_SA_EMAIL: ${module.lz.github_oidc_details.service_account_email}

      Configured for GitHub Organization: ${module.lz.github_oidc_details.github_org}

      Allowed Repositories:
      - ${join("\n- ", module.lz.github_oidc_details.allowed_repositories)}

      Note: Wait 5-10 minutes after creation before trying to obtain tokens!
    EOT
  } : null
}

output "docker_repository" {
  description = "Artifact Registry Docker repository (only shown if repository was created)"
  value = var.docker_repository.create_docker_repository ? {
    name = module.lz.docker_repository.name
    uri  = module.lz.docker_repository.uri
  } : null
}

output "secret_ids" {
  description = "List of secret IDs created (only shown if secrets were created)"
  value = var.secrets != {} ? {
    for name, secret_id in module.lz.secret_ids : name => secret_id
  } : null
}
