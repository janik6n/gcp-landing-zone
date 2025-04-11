variable "project" {
  description = "The GCP project name"
  type        = string
}

variable "environment" {
  description = "The environment where the Cloud Run service will be deployed"
  type        = string
}

variable "workload_identity_pool_disabled" {
  description = "Disable the workload identity pool"
  type        = bool
  default     = false
}

variable "workload_identity_pool_provider_disabled" {
  description = "Disable the workload identity pool provider"
  type        = bool
  default     = false
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
}

variable "allowed_repositories" {
  description = "Allowed repositories"
  type        = set(string)
}

variable "allowed_roles" {
  description = "Allowed roles"
  type        = set(string)
}
