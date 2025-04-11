locals {
  notification_channel_name = "${var.app_name}-${var.environment}-errors"
  # alert_policy_name         = "${var.app_name}-${var.environment}-errors-policy"

  required_apis = [
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]
}
