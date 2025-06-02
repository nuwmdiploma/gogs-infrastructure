remote_state {
  backend = "gcs"
config = {
    bucket = "${get_env("GOGS_ENV", "prod-01-europe-west4-gogs")}-state-bucket"
    prefix = "terraform/gogs-state"
    project        = "diploma-459419"
    region         = "europe-west4"
  }
generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
