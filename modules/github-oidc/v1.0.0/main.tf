/**
 * # GCP OIDC configuration for GitHub Actions
 *
 * version: 1.0.0
 *
 * This module creates OIDC configuration for GitHub Actions in GCP.
 *
 * Example usage:
 * ```hcl
 * module "mod_docker_repository" {
 *  source   = "../modules/github-oidc/v1.0.0"
 *
 *  project                                  = var.project
 *  environment                              = var.environment
 *  workload_identity_pool_disabled          = var.github_oidc.workload_identity_pool_disabled
 *  workload_identity_pool_provider_disabled = var.github_oidc.workload_identity_pool_provider_disabled
 *  github_org                               = var.github_oidc.github_org
 *  allowed_repositories                     = var.github_oidc.allowed_repositories
 *  allowed_roles                            = var.github_oidc.allowed_roles
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

# Service Account
resource "google_service_account" "this" {
  project      = var.project
  account_id   = local.sa_name
  description  = local.sa_description
  display_name = local.sa_name
}

# Workload Identity Pool
resource "google_iam_workload_identity_pool" "this" {
  project                   = var.project
  workload_identity_pool_id = local.identity_pool_id
  display_name              = local.identity_pool_id
  description               = local.identity_pool_description
  disabled                  = var.workload_identity_pool_disabled
}

resource "google_iam_workload_identity_pool_provider" "this" {
  project                            = var.project
  workload_identity_pool_id          = google_iam_workload_identity_pool.this.workload_identity_pool_id
  workload_identity_pool_provider_id = local.identity_pool_provider_id
  display_name                       = local.identity_pool_provider_id
  description                        = local.identity_pool_provider_description
  disabled                           = var.workload_identity_pool_provider_disabled
  attribute_condition                = <<EOT
    assertion.repository_owner == "${var.github_org}"
EOT
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Map allowed repositories to the workload identity pool
resource "google_service_account_iam_member" "this" {
  for_each = var.allowed_repositories
  # "projects/my-project/serviceAccounts/foo-service-account@my-project.iam.gserviceaccount.com"
  service_account_id = "projects/${var.project}/serviceAccounts/${google_service_account.this.email}"
  role               = "roles/iam.workloadIdentityUser"
  # "attribute.repository/github_org/reponame"
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.this.name}/attribute.repository/${var.github_org}/${each.value}"
}

# IAM Policies for SA, i.e. which roles can be assumed by the service account / GitHub Actions
resource "google_project_iam_member" "this" {
  for_each = var.allowed_roles
  project  = var.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.this.email}"
}
