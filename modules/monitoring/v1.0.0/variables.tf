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
  description = "The environment name."
  type        = string
}

variable "alert_notification_channels" {
  description = "Map of notification channels"
  type = map(object({
    type    = string # email
    address = string
  }))
}

variable "log_alerts" {
  description = "Map of alert configurations"
  type = map(object({
    severity                = string
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
  description = "Map of alert configurations"
  type = map(object({
    severity           = string
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
