# terraform {
#   backend "gcs" {
#     bucket = ""
#     prefix = ""
#   }
#   required_version = ">= 1.12.1"
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "~> 5.30.0"
#     }
#   }
# }

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
