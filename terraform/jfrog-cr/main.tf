terraform {
  backend "gcs" {
    bucket = "us-east5-jcr-tf-state"
    prefix = "terraform/init"
  }
  required_version = ">= 1.8.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
