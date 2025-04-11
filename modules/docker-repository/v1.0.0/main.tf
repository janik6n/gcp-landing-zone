/**
 * # GCP Artifact Registry Repository Module for container images
 *
 * version: 1.0.0
 *
 * This module creates Artifact Registry Repository for container images.
 *
 * Example usage:
 * ```hcl
 * module "mod_docker_repository" {
 *  source   = "../modules/docker-repository/v1.0.0"
 *
 *  project                = var.project
 *  region                 = var.region
 *  app_name               = var.app_name
 *  environment            = var.environment
 *  versions_to_keep       = var.docker_repository.versions_to_keep
 *  delete_older_than      = var.docker_repository.delete_older_than
 *  cleanup_dryrun         = var.docker_repository.cleanup_dryrun
 *  vulnerability_scanning = var.docker_repository.vulnerability_scanning
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

resource "google_artifact_registry_repository" "this" {
  project       = var.project
  location      = var.region
  repository_id = local.repository_name
  description   = local.repository_description
  format        = "docker"

  cleanup_policy_dry_run = var.cleanup_dryrun
  cleanup_policies {
    id     = "keep-last-${var.versions_to_keep}-versions"
    action = "KEEP"
    most_recent_versions {
      keep_count = var.versions_to_keep
    }
  }
  cleanup_policies {
    id     = "delete-older-versions"
    action = "DELETE"
    condition {
      older_than = var.delete_older_than
    }
  }

  vulnerability_scanning_config {
    enablement_config = var.vulnerability_scanning ? "INHERITED" : "DISABLED"
  }

  labels = {
    environment = var.environment
    project     = var.project
  }
}
