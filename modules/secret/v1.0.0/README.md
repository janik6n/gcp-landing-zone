# GCP Secrets Manager Secret

version: 1.0.0

This module creates an Secrets Manager Secret. Secret versions are not created.

Example usage:
```hcl
module "mod_secrets" {
 source   = "../modules/secret/v1.0.0"
 for_each = var.secrets

 project     = var.project
 region      = var.region
 app_name    = var.app_name
 environment = var.environment
 secret_name = each.value
}
```

*Note: This README is generated with **terraform-docs**, do not edit directly!*

Instead, edit in the beginning of `main.tf` in the module root directory and run:
`terraform-docs markdown table . >README.md`

## Requirements

| Name | Version |
|------|---------|
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
| [google_project_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_secret_manager_secret.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | App Name. Resource names are derived from this and environment. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment where the Cloud Run service will be deployed | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The GCP project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region where resources will be created | `string` | `"europe-north1"` | no |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Name for secret. This DOES NOT create secret versions. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment"></a> [environment](#output\_environment) | Environment |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | Secret resource ID |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Secret name |
