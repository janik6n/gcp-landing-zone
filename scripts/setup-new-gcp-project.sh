#!/bin/zsh

# Exit on error, fail on pipe errors, exit on undefined variables
set -euo pipefail

validate_project_name() {
  local project_name="$1"

  # Check if project name is empty
  if [[ -z "$project_name" ]]; then
    echo "Error: Project name cannot be empty."
    return 1
  fi

  # Check length
  if [[ ${#project_name} -lt 4 || ${#project_name} -gt 30 ]]; then
    echo "Error: Project name must be between 4 and 30 characters."
    return 1
  fi

  # Check allowed characters using extended globbing
  # I have set more strict rules here than Google, you can adjust them as needed
  if [[ ! "$project_name" =~ ^[a-zA-Z0-9-]*$ ]]; then
    echo "Error: Project name contains invalid characters. Allowed characters are letters, numbers, and hyphens."
    return 1
  fi

  # Check if it starts with a letter
  if [[ ! "$project_name" =~ ^[a-zA-Z] ]]; then
    echo "Error: Project name must start with a uppercase or lowercase letter."
    return 1
  fi

  # Check if it starts or ends with a hyphen
  if [[ "$project_name" == -* || "$project_name" == *- ]]; then
    echo "Error: Project name cannot start or end with a hyphen."
    return 1
  fi

  # Check for reserved keyword "goog" in the beginning (case-insensitive)
  if [[ "${project_name:l}" == goog* ]]; then
    echo "Error: Project name cannot start with 'goog'."
    return 1
  fi

  echo "Project name '$project_name' is valid."
  return 0
}

validate_region() {
    local region="$1"

    # Check if region is empty
    if [[ -z "$region" ]]; then
        echo "Error: Region cannot be empty."
        return 1
    fi

    echo "Region '$region' is valid."
    return 0
}

# Check if project name and region (for storage bucket) is provided as arguments
if [ $# -ne 2 ]; then
    echo "Error: Both project name and region are required"
    echo "Usage: $0 <project-name> <region>"
    echo "Region must be one of Google Cloud regions which support Cloud Storage."
    exit 1
fi

if validate_project_name "$1"; then
  echo "Project name validated successfully!"
  # Proceed with project creation or other actions
else
  echo "Project name validation failed. Please try again."
  exit 1 # Exit with error code
fi

# Validate region (second argument)
if ! validate_region "$2"; then
    echo "Region validation failed. Please provide valid Google Cloud region."
    exit 1
fi

# Create new project in Google Cloud Platform

# Get project name from first argument
GCP_PROJECT_NAME="$1"
GCP_REGION="$2"
echo "Creating new project: $GCP_PROJECT_NAME..."
gcloud projects create "$GCP_PROJECT_NAME"
echo "Project created: $GCP_PROJECT_NAME"
# Save Project ID
echo "Get Project ID..."
GCP_PROJECT=$(gcloud projects describe "$GCP_PROJECT_NAME" --format="value(projectId)")
# Set active project
echo "Setting active project: $GCP_PROJECT..."
gcloud config set project "$GCP_PROJECT"
# Get active project
gcloud config get-value project

# Sleep a bit to let the project to be created
echo "Sleeping 5 seconds to let the project be created before continuing..."
sleep 5

# Get billing account ID, which is needed for linking (we have only one of them):
echo "Get billing account ID..."
GCP_BILLING_ACCOUNT=$(gcloud beta billing accounts list --filter=open=true --format="value(ACCOUNT_ID)")
# Link project to billing account
echo "Link project $GCP_PROJECT to billing account $GCP_BILLING_ACCOUNT ..."
gcloud beta billing projects link "$GCP_PROJECT" --billing-account="$GCP_BILLING_ACCOUNT"
echo "Project $GCP_PROJECT linked to billing account $GCP_BILLING_ACCOUNT"

# Sleep a bit before continuing
echo "Sleeping 5 seconds before continuing..."
sleep 5

# Enable APIs, which are going to be used in the project
# This is done here instead of in TF, because this way we can avoid HTTP 403 errors
# or long artificial delays between API enabling and using them in TF

# Define required APIs
REQUIRED_APIS=(
    "artifactregistry.googleapis.com"
    "clouderrorreporting.googleapis.com"
    "cloudresourcemanager.googleapis.com"
    "cloudscheduler.googleapis.com"
    "dns.googleapis.com"
    "iam.googleapis.com"
    "iamcredentials.googleapis.com"
    "pubsub.googleapis.com"
    "run.googleapis.com"
    "secretmanager.googleapis.com"
)

echo "Enabling required APIs in the project..."
for api in "${REQUIRED_APIS[@]}"; do
    echo "Enabling $api..."
    gcloud services enable "$api" --project "${GCP_PROJECT}"
done
echo "All required APIs enabled successfully."

# Create Cloud Storage Bucket for TF statefiles
echo "Creating Cloud Storage bucket for TF state backend..."
random_suffix=$(openssl rand -hex 4)
# Create bucket name with random suffix
BUCKET_NAME="${GCP_PROJECT_NAME}-${random_suffix}"
echo "Creating Cloud Storage bucket with generated name: ${BUCKET_NAME}..."
echo "- Region: $GCP_REGION"
echo "- Public access is disabled"
echo "- Uniform bucket-level access is enabled"
echo "- Soft delete is enabled with 30 days retention"
echo "- Default storage class is set to STANDARD"
echo "- Bucket versioning is enabled"
echo ""
gcloud storage buckets create gs://"${BUCKET_NAME}" --project="$GCP_PROJECT" --default-storage-class=standard --location="$GCP_REGION" --uniform-bucket-level-access --soft-delete-duration=30d --public-access-prevention
echo "Enable bucket versioning..."
sleep 5
gcloud storage buckets update gs://"${BUCKET_NAME}" --project="$GCP_PROJECT" --versioning
echo "Storage Bucket created for TF backend: ${BUCKET_NAME}"
echo -n "${BUCKET_NAME}" | pbcopy
echo "Bucket name is copied to clipboard."
echo ""
echo "New project bootstrapping completed successfully!"
echo "Allow app service (API) activations to propagate before continuing. Wait 5-10 minutes."
