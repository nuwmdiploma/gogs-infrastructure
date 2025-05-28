data "google_compute_network" "default" {
  name = "default"
}


resource "google_storage_bucket" "terraform_state_bucket" {
  name          = "${var.env}-${var.region}-gogs-state-bucket"
  force_destroy = true
  location      = var.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  uniform_bucket_level_access = true
}
