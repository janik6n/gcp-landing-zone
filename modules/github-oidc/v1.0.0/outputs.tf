output "project_name" {
  description = "Project Name"
  value       = var.project
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "workload_identity_pool_provider_name" {
  description = "Workload Identity Pool Provider Name"
  value       = google_iam_workload_identity_pool_provider.this.name
}

output "service_account_email" {
  description = "Service Account Email"
  value       = google_service_account.this.email
}
