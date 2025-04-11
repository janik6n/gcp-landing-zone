/**
 * # GCP Secrets Manager Secret
 *
 * version: 1.0.0
 *
 * This module creates an Secrets Manager Secret. Secret versions are not created.
 *
 * Example usage:
 * ```hcl
 * module "mod_secrets" {
 *  source   = "../modules/secret/v1.0.0"
 *  for_each = var.secrets
 *
 *  project     = var.project
 *  region      = var.region
 *  app_name    = var.app_name
 *  environment = var.environment
 *  secret_name = each.value
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

resource "google_secret_manager_secret" "this" {
  project   = var.project
  secret_id = var.secret_name # local.secret_id
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  labels = {
    environment = var.environment
    project     = var.project
  }
}
