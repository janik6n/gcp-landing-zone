# GCP Landing Zone module

This repository contains an example Google Cloud Platform Project Landing Zone OpenTofu module. The Landing Zone module manages following resources:
- GitHub Actions OIDC configuration & Service account
- Log & metric alerts and alert policies
- Artifact Registry Repository for container images
- Secret Manager secrets (not secret versions)

See [GCP Project Landing Zone module documentation](../modules/gcp-project-landing-zone/v1.0.0/README.md) for detailed information about the LZ module. The LZ module itself uses few modules to promote reusability.

This configuration is used with [OpenTofu](https://opentofu.org/), but can easily be adjusted to be used with Terraform. No OpenTofu specific features are used.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.18 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.18 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mod_docker_repository"></a> [mod\_docker\_repository](#module\_mod\_docker\_repository) | ./modules/docker-repository/v1.0.0 | n/a |
| <a name="module_mod_github_oidc"></a> [mod\_github\_oidc](#module\_mod\_github\_oidc) | ./modules/github-oidc/v1.0.0 | n/a |
| <a name="module_mod_monitoring"></a> [mod\_monitoring](#module\_mod\_monitoring) | ./modules/monitoring/v1.0.0 | n/a |
| <a name="module_mod_secrets"></a> [mod\_secrets](#module\_mod\_secrets) | ./modules/secret/v1.0.0 | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_notification_channels"></a> [alert\_notification\_channels](#input\_alert\_notification\_channels) | Map of notification channels | <pre>map(object({<br/>    type    = string # email<br/>    address = string<br/>  }))</pre> | `{}` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | App Name. Resource names are derived from this and environment. | `string` | n/a | yes |
| <a name="input_docker_repository"></a> [docker\_repository](#input\_docker\_repository) | Artifact Registry Docker repository configuration settings | <pre>object({<br/>    create_docker_repository = bool<br/>    versions_to_keep         = number<br/>    delete_older_than        = string<br/>    cleanup_dryrun           = bool<br/>    vulnerability_scanning   = bool<br/>  })</pre> | n/a | yes |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enable monitoring | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment where the Cloud Run service will be deployed | `string` | n/a | yes |
| <a name="input_github_oidc"></a> [github\_oidc](#input\_github\_oidc) | GitHub OIDC configuration settings | <pre>object({<br/>    create_github_oidc_configuration         = bool<br/>    workload_identity_pool_disabled          = bool<br/>    workload_identity_pool_provider_disabled = bool<br/>    github_org                               = string<br/>    allowed_repositories                     = set(string)<br/>    allowed_roles                            = set(string)<br/>  })</pre> | n/a | yes |
| <a name="input_log_alerts"></a> [log\_alerts](#input\_log\_alerts) | Map of log alert configurations | <pre>map(object({<br/>    severity                = string # ERROR, CRITICAL<br/>    additional_filters      = optional(list(string))<br/>    link_display_name       = string<br/>    link_url                = string<br/>    auto_close              = string<br/>    documentation           = string<br/>    notification_rate_limit = string<br/>  }))</pre> | `{}` | no |
| <a name="input_metric_alerts"></a> [metric\_alerts](#input\_metric\_alerts) | Map of metric alert configurations | <pre>map(object({<br/>    severity           = string # ERROR, CRITICAL<br/>    link_display_name  = string<br/>    link_url           = string<br/>    auto_close         = string<br/>    documentation      = string<br/>    filter             = string # "resource.type = \"pubsub_subscription\" AND metric.type = \"pubsub.googleapis.com/subscription/num_undelivered_messages\" AND metadata.system_labels.topic_id = \"pubsub-app-test-dl-topic\""<br/>    duration           = string # "300s"<br/>    comparison         = string # "COMPARISON_GT"<br/>    alignment_period   = string # "300s"<br/>    per_series_aligner = string # "ALIGN_MAX"<br/>  }))</pre> | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | The GCP project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region where resources will be created | `string` | `"europe-north1"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | List of secrets to create. This DOES NOT create secret versions. | `set(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_docker_repository"></a> [docker\_repository](#output\_docker\_repository) | Artifact Registry Docker repository (only shown if repository was created) |
| <a name="output_environment"></a> [environment](#output\_environment) | Environment name |
| <a name="output_github_oidc_details"></a> [github\_oidc\_details](#output\_github\_oidc\_details) | GitHub OIDC configuration details (only shown if OIDC was configured) |
| <a name="output_monitoring_log_alerts"></a> [monitoring\_log\_alerts](#output\_monitoring\_log\_alerts) | Monitoring configuration details for log alerts (only shown if alerts were configured) |
| <a name="output_monitoring_metric_alerts"></a> [monitoring\_metric\_alerts](#output\_monitoring\_metric\_alerts) | Monitoring configuration details for metric alerts (only shown if alerts were configured) |
| <a name="output_monitoring_notification_channels"></a> [monitoring\_notification\_channels](#output\_monitoring\_notification\_channels) | Monitoring notification channels (only shown if channels were configured) |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name |
| <a name="output_secret_ids"></a> [secret\_ids](#output\_secret\_ids) | List of secret IDs created (only shown if secrets were created) |


## Prerequisites

Initial setup is done on laptop, further iterations can be run with GitHub Actions after setting those up. Make sure these prerequisites are met before continuing:

1. Install [OpenTofu](https://opentofu.org/). Version 1.9.* is required. *Note: None of OpenTofu specific features are used, so you can use Terraform instead. In this case check all version constraints! (look for all occurances of `required_version` on repo-scope).*
2. Install [gcloud CLI](https://cloud.google.com/sdk/gcloud). Version 509.* is expected.
3. Make sure you have the required permissions to:
  - [Create projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project)
  - [Link the Cloud Billing account](https://cloud.google.com/billing/docs/how-to/modify-project#required-permissions-change)
  - In addition, you are expected to get/have `roles/admin` to the newly created project.
3. Login to Google Cloud on the CLI.
4. OpenTofu (and Terraform) will use local authentication credentials, so create them with:
    ```bash
    gcloud auth application-default login
    ```
5. You are now ready to proceed.

## How to use this module

A working example is found in `./example` directory. Following commands are expected to be run in this directory.

This module expects, that a clean GCP Project exists with billing project association, and a Storage bucket for TF backend. If you need to create a new GCP Project, see [Bonus: Create new GCP Project for LZ](#bonus-create-new-gcp-project-for-lz) below.

1. Edit TF configuration in `environment.auto.tfvars` and `providers.tf`.
2. Step-by-step:
   ```bash
   # format source code
   tofu fmt -recursive
   # init
   tofu init
   # validate
   tofu validate
   # plan
   tofu plan -out=env.tfplan
   # apply
   tofu apply env.tfplan
   ```

If you need to completely delete the Landing Zone, run
```bash
tofu destroy
```

## About GitHub Actions OIDC

This LZ module creates OIDC configuration for GitHub Actions, assuming you will use https://github.com/google-github-actions/setup-gcloud for authentication in your workflow.

Actions workflow authenticate to GCP using project-specific OIDC configuration and Service account.

Project / environment specific Actions secrets must be created, for example:
  - `GCP_SA_EMAIL_DEV`
  - `GCP_WORKLOAD_IDENTITY_PROVIDER_DEV`

`DEV` in the above corresponds to the environment you set in `environment.auto.tfvars`, but this is not "hard mapping" so feel free to use what ever secret names you want.

## Bonus: Create new GCP Project for LZ

To create a new Project, and some other things:
- Create new Project
- Associate it with existing Billing Project (assuming there is only one of them)
- Enable following Cloud APIs:
  - artifactregistry.googleapis.com
  - clouderrorreporting.googleapis.com
  - cloudresourcemanager.googleapis.com
  - cloudscheduler.googleapis.com
  - dns.googleapis.com
  - iam.googleapis.com
  - iamcredentials.googleapis.com
  - pubsub.googleapis.com
  - run.googleapis.com
  - secretmanager.googleapis.com
- Create Cloud Storage bucket for TF state backend

```bash
# run
./scripts/setup-new-gcp-project.sh [project-name] [GCP-region]
```

Save the printed Storage Bucket name for further use in Landing Zone configuration.

**Note: This was created and used with `zsh` shell. Adjust as needed for your shell of choice.**

## Changelog

[CHANGELOG](CHANGELOG.md)

## License

MIT [License](LICENSE). Copyright janik6n.
