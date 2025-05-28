resource "google_compute_network" "vpc_network" {
  name                            = "${var.region}-${var.app}-vpc"
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
}

resource "google_compute_subnetwork" "sub_network" {
  name          = "${var.region}-${var.app}-subnet-main"
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_firewall" "allow_ports" {
  name    = "${var.region}-${var.app}-allow-ports"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8081", "8082"]
  }
  source_ranges = ["0.0.0.0/0"]
}
