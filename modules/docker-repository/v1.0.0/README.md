# GCP Artifact Registry Repository Module for container images

version: 1.0.0

This module creates Artifact Registry Repository for container images.

Example usage:
```hcl
module "mod_docker_repository" {
 source   = "../modules/docker-repository/v1.0.0"

 project                = var.project
 region                 = var.region
 app_name               = var.app_name
 environment            = var.environment
 versions_to_keep       = var.docker_repository.versions_to_keep
 delete_older_than      = var.docker_repository.delete_older_than
 cleanup_dryrun         = var.docker_repository.cleanup_dryrun
 vulnerability_scanning = var.docker_repository.vulnerability_scanning
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
| [google_artifact_registry_repository.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository) | resource |
| [google_project_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | App Name. Resource names are derived from this and environment. | `string` | n/a | yes |
| <a name="input_cleanup_dryrun"></a> [cleanup\_dryrun](#input\_cleanup\_dryrun) | Dry run cleanup policies | `bool` | `false` | no |
| <a name="input_create_docker_repository"></a> [create\_docker\_repository](#input\_create\_docker\_repository) | Create a Docker repository in Artifact Registry | `bool` | `true` | no |
| <a name="input_delete_older_than"></a> [delete\_older\_than](#input\_delete\_older\_than) | Delete images older than this duration | `string` | `"3d"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment where the Cloud Run service will be deployed | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The GCP project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region where resources will be created | `string` | `"europe-north1"` | no |
| <a name="input_versions_to_keep"></a> [versions\_to\_keep](#input\_versions\_to\_keep) | Number of versions to keep in the Artifact Registry | `number` | `5` | no |
| <a name="input_vulnerability_scanning"></a> [vulnerability\_scanning](#input\_vulnerability\_scanning) | Enable vulnerability scanning. Note that this costs money! | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment"></a> [environment](#output\_environment) | Environment name |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | Repository name |
| <a name="output_repository_uri"></a> [repository\_uri](#output\_repository\_uri) | URI of the Docker repository in Artifact Registry |
