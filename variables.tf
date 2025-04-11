variable "project" {
  description = "The GCP project name"
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created"
  type        = string
  default     = "europe-north1" # Finland

  validation {
    condition     = contains(["europe-north1", "europe-west3"], var.region)
    error_message = "Region must be one of these: 'europe-north1','europe-west3'"
  }
}

variable "app_name" {
  description = "App Name. Resource names are derived from this and environment."
  type        = string

  validation {
    condition     = length(var.app_name) > 2 && length(var.app_name) < 20
    error_message = "App name must be between 2 and 20 characters."
  }
}

variable "environment" {
  description = "The environment where the Cloud Run service will be deployed"
  type        = string
}

variable "docker_repository" {
  description = "Artifact Registry Docker repository configuration settings"
  type = object({
    create_docker_repository = bool
    versions_to_keep         = number
    delete_older_than        = string
    cleanup_dryrun           = bool
    vulnerability_scanning   = bool
  })
}

variable "github_oidc" {
  description = "GitHub OIDC configuration settings"
  type = object({
    create_github_oidc_configuration         = bool
    workload_identity_pool_disabled          = bool
    workload_identity_pool_provider_disabled = bool
    github_org                               = string
    allowed_repositories                     = set(string)
    allowed_roles                            = set(string)
  })
}

variable "secrets" {
  description = "List of secrets to create. This DOES NOT create secret versions."
  type        = set(string)
}

variable "enable_monitoring" {
  description = "Enable monitoring"
  type        = bool
  default     = true
}

variable "log_alerts" {
  description = "Map of log alert configurations"
  type = map(object({
    severity                = string # ERROR, CRITICAL
    additional_filters      = optional(list(string))
    link_display_name       = string
    link_url                = string
    auto_close              = string
    documentation           = string
    notification_rate_limit = string
  }))
  default = {}
}

variable "metric_alerts" {
  description = "Map of metric alert configurations"
  type = map(object({
    severity           = string # ERROR, CRITICAL
    link_display_name  = string
    link_url           = string
    auto_close         = string
    documentation      = string
    filter             = string # "resource.type = \"pubsub_subscription\" AND metric.type = \"pubsub.googleapis.com/subscription/num_undelivered_messages\" AND metadata.system_labels.topic_id = \"pubsub-app-test-dl-topic\""
    duration           = string # "300s"
    comparison         = string # "COMPARISON_GT"
    alignment_period   = string # "300s"
    per_series_aligner = string # "ALIGN_MAX"
  }))
  default = {}
}

variable "alert_notification_channels" {
  description = "Map of notification channels"
  type = map(object({
    type    = string # email
    address = string
  }))
  default = {}
}
