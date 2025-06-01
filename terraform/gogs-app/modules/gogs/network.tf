resource "google_compute_network" "gogs-network" {
  name                     = "${var.env}-${var.region}-gogs-network"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}
resource "google_compute_subnetwork" "gogs-subnetwork" {
  name                     = "${var.env}-${var.region}-subnetwork"
  ip_cidr_range            = "10.0.0.0/16"
  region                   = var.region
  private_ip_google_access = true
  network                  = google_compute_network.gogs-network.id
}

resource "google_compute_global_address" "ip_address" {
  name = "gogs-${var.env}-ip"
  #address_type = "EXTERNAL"
  #region       = "${var.region}"
}