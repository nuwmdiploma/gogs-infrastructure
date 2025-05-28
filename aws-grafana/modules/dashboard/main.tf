terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "2.8.1"
    }
  }
}
provider "grafana" {
  url  = var.workspace_url
  auth = var.auth_key
}
