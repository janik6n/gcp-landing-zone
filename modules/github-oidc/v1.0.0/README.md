# GCP OIDC configuration for GitHub Actions

version: 1.0.0

This module creates OIDC configuration for GitHub Actions in GCP.

Example usage:
```hcl
module "mod_docker_repository" {
 source   = "../modules/github-oidc/v1.0.0"

 project                                  = var.project
 environment                              = var.environment
 workload_identity_pool_disabled          = var.github_oidc.workload_identity_pool_disabled
 workload_identity_pool_provider_disabled = var.github_oidc.workload_identity_pool_provider_disabled
 github_org                               = var.github_oidc.github_org
 allowed_repositories                     = var.github_oidc.allowed_repositories
 allowed_roles                            = var.github_oidc.allowed_roles
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
| [google_iam_workload_identity_pool.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_project_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_repositories"></a> [allowed\_repositories](#input\_allowed\_repositories) | Allowed repositories | `set(string)` | n/a | yes |
| <a name="input_allowed_roles"></a> [allowed\_roles](#input\_allowed\_roles) | Allowed roles | `set(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment where the Cloud Run service will be deployed | `string` | n/a | yes |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | GitHub organization name | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The GCP project name | `string` | n/a | yes |
| <a name="input_workload_identity_pool_disabled"></a> [workload\_identity\_pool\_disabled](#input\_workload\_identity\_pool\_disabled) | Disable the workload identity pool | `bool` | `false` | no |
| <a name="input_workload_identity_pool_provider_disabled"></a> [workload\_identity\_pool\_provider\_disabled](#input\_workload\_identity\_pool\_provider\_disabled) | Disable the workload identity pool provider | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment"></a> [environment](#output\_environment) | Environment name |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project Name |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | Service Account Email |
| <a name="output_workload_identity_pool_provider_name"></a> [workload\_identity\_pool\_provider\_name](#output\_workload\_identity\_pool\_provider\_name) | Workload Identity Pool Provider Name |
