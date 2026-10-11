# AGENTS.md

Guidance for AI coding agents working in this repository. Human-facing documentation lives in [README.md](README.md).

## Project overview

An example **Google Cloud Platform project Landing Zone** written as an [OpenTofu](https://opentofu.org/) module (Terraform-compatible; no OpenTofu-specific features are used). It manages, per project/environment:

- GitHub Actions OIDC (Workload Identity Federation) and a service account
- Log and metric alerts, alert policies, and notification channels
- Artifact Registry Docker repository with cleanup policies
- Secret Manager secrets (never secret versions)

## Repository layout

```
.                      # Root LZ module: main.tf, variables.tf, outputs.tf, locals.tf, providers.tf
├── modules/<name>/
│   ├── CHANGELOG.md   # Per-module changelog
│   └── vX.Y.Z/        # Immutable, versioned module implementation
├── example/           # Consumer example (backend, provider config, *.auto.tfvars)
└── scripts/           # Helper scripts (e.g. setup-new-gcp-project.sh, zsh)
```

Current sub-modules: `docker-repository`, `github-oidc`, `monitoring`, `secret` (all `v1.0.0`).

## Tooling

- OpenTofu `~> 1.9` (`tofu`); Terraform works too, but check every `required_version`.
- Google provider `hashicorp/google` (`~> 6.18` at root, `~> 6.27` in sub-modules and example).
- [terraform-docs](https://terraform-docs.io/) for module READMEs.
- `gcloud` CLI for authentication and the bootstrap script.

## Validation

Run before proposing changes (no cloud credentials required):

```bash
tofu fmt -recursive -check          # or `tofu fmt -recursive` to fix
cd example && tofu init -backend=false && tofu validate
```

- Never run `tofu plan`, `apply`, `destroy`, `import`, or `state` commands, or `scripts/setup-new-gcp-project.sh`, unless the user explicitly asks — they touch real GCP resources and remote state.
- There is no CI or automated test suite; `fmt` + `validate` is the baseline.

## Conventions

### Modules and versioning

- Sub-modules are versioned by directory (`modules/<name>/vX.Y.Z`) and referenced by relative path, e.g. `source = "./modules/secret/v1.0.0"`.
- Treat released version directories as immutable. For a change to a module, create a new version directory (copy the previous one), bump the version in its header, and update the `source` in the root `main.tf`.
- Each module version contains `main.tf`, `variables.tf`, `outputs.tf`, `locals.tf`, `providers.tf`, and a generated `README.md`.
- Optional modules are toggled with `count = var.<x>.create_... ? 1 : 0` or `var.enable_... ? 1 : 0`; collections use `for_each`.
- Use `this` as the name for a module's primary resource/data source (e.g. `google_secret_manager_secret.this`).
- Required APIs are declared in `local.required_apis` and enabled via `google_project_service.this` with `disable_on_destroy = false`.
- Resource names derive from `app_name` and `environment`; label resources with `environment` and `project`.

### Variables and outputs

- Every variable and output has a `description` and an explicit `type`. Group related settings into `object({...})` variables (see `github_oidc`, `docker_repository`).
- New root inputs must be threaded through `example/variables.tf`, `example/main.tf`, and `example/environment.auto.tfvars`.
- Outputs of optional modules must handle the disabled case (they are documented as "only shown if ... was configured").

### Documentation

- Module READMEs are **generated** — do not edit them by hand. Edit the `/** ... */` header comment at the top of the module's `main.tf`, then run in the module version directory:
  ```bash
  terraform-docs markdown table . > README.md
  ```
- The root `README.md` contains terraform-docs tables (Requirements … Outputs) plus hand-written sections. Keep the tables in sync when root inputs/outputs/modules change, and preserve the hand-written prose.

### Changelogs

- Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and [SemVer](https://semver.org/). Sections: Added, Changed, Deprecated, Fixed, Removed, Security, Internal.
- Update the root `CHANGELOG.md` for changes to the LZ module and the relevant `modules/<name>/CHANGELOG.md` for sub-module changes.

## Security

- Never commit state (`*.tfstate`), plan files, `.terraform/`, credentials, or real secret values. Secret Manager **versions** are intentionally created outside Terraform.
- Do not replace placeholder values in `example/` (e.g. backend `bucket = "my-bucket-name"`) with real project IDs or bucket names.
- Changes to `modules/github-oidc` affect who can deploy to GCP. Keep attribute conditions scoped to `github_org` / `allowed_repositories`, and grant only roles listed in `allowed_roles`. Call out any broadening of access explicitly.
