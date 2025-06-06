remote_state {
  backend = "gcs"
config = {
    bucket = "${get_env("GOGS_ENV", "prod-01-europe-central2-gogs")}-bucket"
    prefix = "terraform/gogs-state"
    project        = "diploma-459419"
  }
generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
