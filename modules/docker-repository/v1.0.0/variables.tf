variable "project" {
  description = "The GCP project name"
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created"
  type        = string
  default     = "europe-north1" # Finland
}

variable "app_name" {
  description = "App Name. Resource names are derived from this and environment."
  type        = string
}

variable "environment" {
  description = "The environment where the Cloud Run service will be deployed"
  type        = string
}

variable "versions_to_keep" {
  description = "Number of versions to keep in the Artifact Registry"
  type        = number
  default     = 5
}

variable "delete_older_than" {
  description = "Delete images older than this duration"
  type        = string
  default     = "3d"
}

variable "cleanup_dryrun" {
  description = "Dry run cleanup policies"
  type        = bool
  default     = false
}

variable "vulnerability_scanning" {
  description = "Enable vulnerability scanning. Note that this costs money!"
  type        = bool
  default     = false
}

variable "create_docker_repository" {
  description = "Create a Docker repository in Artifact Registry"
  type        = bool
  default     = true
}
