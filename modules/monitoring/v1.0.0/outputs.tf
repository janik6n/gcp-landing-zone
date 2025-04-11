output "project_name" {
  description = "Project name"
  value       = var.project
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "notification_channels" {
  description = "Details of notification channels"
  value = {
    for name, channel in google_monitoring_notification_channel.this : name => {
      name    = channel.display_name
      type    = channel.type
      address = channel.labels["email_address"]
    }
  }
}

output "log_alerts" {
  description = "Details of log alert policies"
  value = {
    for name, alert in google_monitoring_alert_policy.this : name => {
      name       = alert.display_name
      severity   = alert.severity
      conditions = alert.conditions
      alert_strategy = {
        auto_close = alert.alert_strategy[0].auto_close
        rate_limit = alert.alert_strategy[0].notification_rate_limit[0].period
      }
    }
  }
}

output "metric_alerts" {
  description = "Details of metric alert policies"
  value = {
    for name, alert in google_monitoring_alert_policy.metrics : name => {
      name       = alert.display_name
      severity   = alert.severity
      conditions = alert.conditions
      alert_strategy = {
        auto_close = alert.alert_strategy[0].auto_close
      }
    }
  }
}
