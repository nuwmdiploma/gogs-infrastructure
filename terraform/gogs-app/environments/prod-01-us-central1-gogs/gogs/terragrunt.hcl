terraform {
  source = "../../../modules/gogs"

  extra_arguments "custom_args" {
    commands = [
      "apply",
      "destroy"
    ]
    arguments = [
      "-auto-approve",
      "-no-color"
    ]
  }

  extra_arguments "plan_args" {
    commands  = ["plan"]
    arguments = ["-no-color"]
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
    env = "prod-01"
    region = "us-central1"
    project = "diploma-459419" 
    zone = "us-central1-c"
    machine_type = "e2-medium"
    helm_repo = "https://jfrog.nuwm-diploma.pp.ua/artifactory/api/helm/helm-gogs-local"
}
