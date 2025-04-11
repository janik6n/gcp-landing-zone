# GCP Project Monitoring

version: 1.0.0

This module creates a monitoring setup for GCP Project.

Example usage:
```hcl
module "mod_monitoring" {
 source   = "../modules/monitoring/v1.0.0"

 region                      = var.region
 project                     = var.project
 app_name                    = var.app_name
 environment                 = var.environment
 alert_notification_channels = var.alert_notification_channels
 log_alerts                  = var.log_alerts
 metric_alerts               = var.metric_alerts
}
```

*Note: This README is generated with **terraform-docs**, do not edit directly!*

Instead, edit in the beginning of `main.tf` in the module root directory and run:
`terraform-docs markdown table . >README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.27 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_monitoring_alert_policy.metrics](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_notification_channel.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_project_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_notification_channels"></a> [alert\_notification\_channels](#input\_alert\_notification\_channels) | Map of notification channels | <pre>map(object({<br/>    type    = string # email<br/>    address = string<br/>  }))</pre> | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | App Name. Resource names are derived from this and environment. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. | `string` | n/a | yes |
| <a name="input_log_alerts"></a> [log\_alerts](#input\_log\_alerts) | Map of alert configurations | <pre>map(object({<br/>    severity                = string<br/>    additional_filters      = optional(list(string))<br/>    link_display_name       = string<br/>    link_url                = string<br/>    auto_close              = string<br/>    documentation           = string<br/>    notification_rate_limit = string<br/>  }))</pre> | `{}` | no |
| <a name="input_metric_alerts"></a> [metric\_alerts](#input\_metric\_alerts) | Map of alert configurations | <pre>map(object({<br/>    severity           = string<br/>    link_display_name  = string<br/>    link_url           = string<br/>    auto_close         = string<br/>    documentation      = string<br/>    filter             = string # "resource.type = \"pubsub_subscription\" AND metric.type = \"pubsub.googleapis.com/subscription/num_undelivered_messages\" AND metadata.system_labels.topic_id = \"pubsub-app-test-dl-topic\""<br/>    duration           = string # "300s"<br/>    comparison         = string # "COMPARISON_GT"<br/>    alignment_period   = string # "300s"<br/>    per_series_aligner = string # "ALIGN_MAX"<br/>  }))</pre> | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | The GCP project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region where resources will be created | `string` | `"europe-north1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment"></a> [environment](#output\_environment) | Environment name |
| <a name="output_log_alerts"></a> [log\_alerts](#output\_log\_alerts) | Details of log alert policies |
| <a name="output_metric_alerts"></a> [metric\_alerts](#output\_metric\_alerts) | Details of metric alert policies |
| <a name="output_notification_channels"></a> [notification\_channels](#output\_notification\_channels) | Details of notification channels |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name |
