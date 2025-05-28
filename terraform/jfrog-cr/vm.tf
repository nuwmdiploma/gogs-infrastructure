resource "google_compute_instance" "frog_jcr_instance" {
  name                = "${var.region}-jfrog-${var.app}-vm"
  machine_type        = var.instance_type
  deletion_protection = var.deletion_protection

  boot_disk {
    initialize_params {
      image = var.image_type
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.sub_network.self_link
    access_config {
      nat_ip = google_compute_address.public_ip.address
    }
  }

  attached_disk {
    device_name = "${var.region}-${var.app}-disk-jfrog-jcr"
    source      = google_compute_disk.disk_jfrog_jcr.id
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")

  metadata = {
    ssh-keys = "${var.region}-${var.app}-jfrog-jcr:${tls_private_key.ssh_key_jfrog_jcr.public_key_openssh}"
  }

  labels = {
    app = var.app
  }
  depends_on = [google_compute_disk.disk_jfrog_jcr, google_compute_network.vpc_network, google_compute_subnetwork.sub_network]
}

resource "google_compute_address" "public_ip" {
  name = "${var.region}-${var.app}-jfrog-jcr-ip"
}

resource "google_compute_disk" "disk_jfrog_jcr" {
  name        = "${var.region}-${var.app}-disk-jfrog-jcr"
  description = "Disk for Jfrog config"
  type        = "pd-ssd"
  size        = var.disk_size
  labels = {
    app = var.app
  }
}
