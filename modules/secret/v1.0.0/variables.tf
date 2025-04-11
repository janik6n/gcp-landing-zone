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
  description = "The environment where the Cloud Run service will be deployed"
  type        = string
}

variable "secret_name" {
  description = "Name for secret. This DOES NOT create secret versions."
  type        = string
}
