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

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "7.24.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

