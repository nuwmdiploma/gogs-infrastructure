resource "google_compute_network" "default" {
  name                    = "awx-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name                     = "awx-subnetwork"
  ip_cidr_range            = "10.154.0.0/20"
  region                   = var.region
  private_ip_google_access = true
  network                  = google_compute_network.default.id
}

resource "google_compute_firewall" "default" {
  name    = "awx-firewall"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443", "30000-32767"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_container_cluster" "awx_cluster" {
  name       = "awx-cluster"
  location   = var.zone
  network    = google_compute_network.default.id
  subnetwork = google_compute_subnetwork.default.id

  initial_node_count       = 1
  remove_default_node_pool = true
  deletion_protection      = false

  lifecycle {
    ignore_changes = all
  }
}

resource "google_container_node_pool" "awx_node_pool" {
  name       = "awx-node-pool"
  cluster    = google_container_cluster.awx_cluster.id
  location   = google_container_cluster.awx_cluster.location
  node_count = 4

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = 20

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}