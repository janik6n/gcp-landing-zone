output "project_name" {
  description = "Project name"
  value       = var.project
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "repository_name" {
  description = "Repository name"
  value       = local.repository_name
}

output "repository_uri" {
  description = "URI of the Docker repository in Artifact Registry"
  # europe-north1-docker.pkg.dev/app-name/reponame
  value = "${var.region}-docker.pkg.dev/${var.project}/${local.repository_name}"
}
