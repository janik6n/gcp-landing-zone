locals {
  # secret_id = "${var.app_name}-${var.environment}-${var.secret_name}"

  required_apis = [
    "secretmanager.googleapis.com",
  ]
}
