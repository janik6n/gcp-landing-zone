/**
 * # GCP Project Monitoring
 *
 * version: 1.0.0
 *
 * This module creates a monitoring setup for GCP Project.
 *
 * Example usage:
 * ```hcl
 * module "mod_monitoring" {
 *  source   = "../modules/monitoring/v1.0.0"
 *
 *  region                      = var.region
 *  project                     = var.project
 *  app_name                    = var.app_name
 *  environment                 = var.environment
 *  alert_notification_channels = var.alert_notification_channels
 *  log_alerts                  = var.log_alerts
 *  metric_alerts               = var.metric_alerts
 * }
 * ```
 *
 *
 * *Note: This README is generated with **terraform-docs**, do not edit directly!*
 *
 * Instead, edit in the beginning of `main.tf` in the module root directory and run:
 * `terraform-docs markdown table . >README.md`
 */

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

resource "google_monitoring_notification_channel" "this" {
  for_each     = var.alert_notification_channels
  project      = var.project
  display_name = each.key
  type         = each.value.type
  labels = {
    email_address = each.value.address
  }

  force_delete = false
}

# Log alerts
resource "google_monitoring_alert_policy" "this" {
  for_each     = var.log_alerts
  project      = var.project
  display_name = "${var.app_name}-${var.environment}-${each.key}"
  documentation {
    content   = each.value.documentation
    mime_type = "text/markdown"
    subject   = "GCP ${var.project} ${each.value.severity} alert"
    links {
      display_name = each.value.link_display_name
      url          = each.value.link_url
    }
  }
  combiner = "OR"
  severity = each.value.severity
  conditions {
    display_name = "${var.app_name}-${var.environment}-${each.key}"

    condition_matched_log {
      filter = <<-EOT
          severity="${each.value.severity}"
          resource.labels.project_id="${var.project}"
          ${join("\n", coalesce(each.value.additional_filters, []))}
        EOT
    }
  }
  alert_strategy {
    notification_rate_limit {
      period = each.value.notification_rate_limit
    }
    auto_close = each.value.auto_close
  }

  notification_channels = [for channel_key, _ in var.alert_notification_channels : google_monitoring_notification_channel.this[channel_key].id]

  user_labels = {
    environment = var.environment
    project     = var.project
  }
}

# Metric alerts
resource "google_monitoring_alert_policy" "metrics" {
  for_each     = var.metric_alerts
  project      = var.project
  display_name = "${var.app_name}-${var.environment}-${each.key}"
  documentation {
    content   = each.value.documentation
    mime_type = "text/markdown"
    subject   = "GCP ${var.project} ${each.value.severity} alert"
    links {
      display_name = each.value.link_display_name
      url          = each.value.link_url
    }
  }
  combiner = "OR"
  severity = each.value.severity
  conditions {
    display_name = "${var.app_name}-${var.environment}-${each.key}"

    condition_threshold {
      filter     = each.value.filter     # "resource.type = \"pubsub_subscription\" AND metric.type = \"pubsub.googleapis.com/subscription/num_undelivered_messages\" AND metadata.system_labels.topic_id = \"pubsub-app-test-dl-topic\""
      duration   = each.value.duration   # "300s"
      comparison = each.value.comparison # "COMPARISON_GT"
      aggregations {
        alignment_period   = each.value.alignment_period   # "300s"
        per_series_aligner = each.value.per_series_aligner # "ALIGN_MAX"
      }
    }
  }
  alert_strategy {
    auto_close = each.value.auto_close
  }

  notification_channels = [for channel_key, _ in var.alert_notification_channels : google_monitoring_notification_channel.this[channel_key].id]

  user_labels = {
    environment = var.environment
    project     = var.project
  }
}
