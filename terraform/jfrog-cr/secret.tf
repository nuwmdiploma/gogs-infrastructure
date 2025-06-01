resource "tls_private_key" "ssh_key_jfrog_jcr" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "google_secret_manager_secret" "ssh_key_jfrog_jcr" {
  secret_id = "${var.region}-${var.app}-ssh_frog-jcr"
  labels = {
    app = var.app
  }
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "ssh_key_jfrogfrog_jcr_version" {
  secret      = google_secret_manager_secret.ssh_key_jfrog_jcr.id
  secret_data = tls_private_key.ssh_key_jfrog_jcr.private_key_openssh
}