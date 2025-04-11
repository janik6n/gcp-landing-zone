output "project_name" {
  description = "Project name"
  value       = var.project
}

output "environment" {
  description = "Environment"
  value       = var.environment
}

output "secret_name" {
  description = "Secret name"
  value       = google_secret_manager_secret.this.secret_id
}

output "secret_id" {
  description = "Secret resource ID"
  value       = "projects/${data.google_project.this.number}/secrets/${google_secret_manager_secret.this.secret_id}"
}
