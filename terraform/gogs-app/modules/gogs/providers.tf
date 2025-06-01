data "google_client_config" "provider" {}

provider "kubernetes" {
  host  = "https://${google_container_cluster.gogs_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
  google_container_cluster.gogs_cluster.master_auth[0].cluster_ca_certificate)
}
provider "helm" {
  kubernetes {
    token                  = data.google_client_config.provider.access_token
    host                   = "https://${google_container_cluster.gogs_cluster.endpoint}"
    cluster_ca_certificate = base64decode(google_container_cluster.gogs_cluster.master_auth[0].cluster_ca_certificate)
  }
  registry {
    url      = var.helm_repo
    username = var.jfrog_username
    password = var.jfrog_password
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}