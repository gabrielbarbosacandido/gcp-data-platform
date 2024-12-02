terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.12.0"
    }
  }
}

provider "google" {
  credentials = var.application_credentials
  project     = var.project
  region      = var.region
}
