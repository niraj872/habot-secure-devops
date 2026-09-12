# Author: NIRAJ KR YADAV
# Email: Nirajyadav9466@gmail.com
# Phone: 7366913096

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.24.0"
    }
  }
}

variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique Terraform state bucket name."
}

variable "region" {
  type    = string
  default = "asia-south2"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "terraform_state" {
  project                     = var.project_id
  name                        = var.state_bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }
}

output "state_bucket" {
  value = google_storage_bucket.terraform_state.name
}


