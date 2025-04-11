project     = "sample-project"
region      = "europe-north1"
app_name    = "lz" # Google does now allow underscores in the IDs (at least for Service Accounts)
environment = "dev"

github_oidc = {
  create_github_oidc_configuration         = true
  workload_identity_pool_disabled          = false
  workload_identity_pool_provider_disabled = false
  github_org                               = "janik6n"
  # Which repositories are allowed to request tokens
  allowed_repositories = [
    "gcp-landing-zone"
  ]
  # Which roles are allowed to be assumed by the identity pool (which are needed in GHA workflows)
  allowed_roles = [
    "roles/iam.serviceAccountUser",
    "roles/iam.workloadIdentityUser",
    "roles/owner"
  ]
}

docker_repository = {
  create_docker_repository = true
  versions_to_keep         = 5
  delete_older_than        = "3d"
  cleanup_dryrun           = false
  vulnerability_scanning   = false
}

enable_monitoring = true

log_alerts = {
  "project-log-error" = {
    severity = "ERROR" # ERROR, CRITICAL
    additional_filters = [
      "-protoPayload.methodName=\"grafeas.v1.Grafeas.ListOccurrences\"" # This will disable the alert for the Container Analysis API, when it is not activated. Would fire when portal is accessed.
    ]
    notification_rate_limit = "3600s"
    auto_close              = "86400s"
    link_display_name       = "Ops handbook"
    link_url                = "https://github.com/janik6n/gcp-landing-zone"
    documentation           = <<-EOT
      This is the quick guide for the error alert.

      ## Next steps

      1. Open this incident in portal.
      2. Investigate the error.
      3. Fix the error.
      4. Close the incident.

      Hope this is helpful!
    EOT
  }
}

metric_alerts = {
  "dl-topic-unacks" = {
    severity           = "ERROR" # ERROR, CRITICAL
    auto_close         = "86400s"
    link_display_name  = "Ops handbook"
    link_url           = "https://github.com/janik6n/gcp-landing-zone"
    documentation      = <<-EOT
      This is the quick guide for the example metric alert.
      As an example, a Pub/Sub topic is used, which has a dead letter topic.

      ## Next steps

      1. Open this incident in portal.
      2. Investigate the metric.
      3. Fix the issue.
      4. Close the incident.

      Hope this is helpful!
    EOT
    filter             = "resource.type = \"pubsub_subscription\" AND metric.type = \"pubsub.googleapis.com/subscription/num_undelivered_messages\" AND metadata.system_labels.topic_id = \"pubsub-app-test-dl-topic\""
    duration           = "300s"
    comparison         = "COMPARISON_GT"
    alignment_period   = "300s"
    per_series_aligner = "ALIGN_MAX"
  }
}

alert_notification_channels = {
  "email_to_someone" = {
    type    = "email" # For now only "email" is supported
    address = "someone@gmail.com"
  }
}

# As an example, a secret called db_connection_string is created in the Secret Manager
secrets = ["db_connection_string"]
