terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3"{
      bucket = "nuwmdiploma-terraform-state"
      key    = "tf/managed-grafana/terraform.tfstate"
      region = "eu-west-1"
      shared_credentials_files = ["~/.aws/credentials"]
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "default"
}