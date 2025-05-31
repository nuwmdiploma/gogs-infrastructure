terraform {
  backend "gcs" {
    bucket = "us-central1-jcr-tf-state"
    prefix = "terraform/init"
  }
  required_version = ">= 1.12.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.37.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
