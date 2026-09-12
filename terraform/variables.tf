# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

variable "project_id" {
  description = "Target GCP project ID."
  type        = string
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "asia-south2"
}

variable "bucket_name" {
  description = "Globally unique D0 Raw Landing bucket name."
  type        = string
}

variable "analytics_group" {
  description = "Google group that can query the permitted analytics rows."
  type        = string
}

variable "data_region" {
  description = "Region visible to the analytics group through the RLS policy."
  type        = string
  default     = "IN-NCR"
}

variable "enable_app_engine" {
  description = "Create the one-per-project App Engine application when bootstrapping a new project."
  type        = bool
  default     = false
}

variable "app_engine_location" {
  description = "App Engine application location. Only used when enable_app_engine is true."
  type        = string
  default     = "asia-south1"
}


variable "github_repository" {
  description = "GitHub repository in OWNER/REPOSITORY format that is allowed to federate into the deployment service account."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.github_repository))
    error_message = "github_repository must use OWNER/REPOSITORY format."
  }
}


