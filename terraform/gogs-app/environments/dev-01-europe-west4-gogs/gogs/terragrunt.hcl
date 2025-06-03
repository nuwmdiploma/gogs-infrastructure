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
    env = "dev-01"
    region = "europe-west4"
    project = "diploma-459419" 
    zone = "europe-west4-c"
    machine_type = "n2d-highcpu-2"
    helm_repo = "https://jfrog.nuwm-diploma.pp.ua/artifactory/api/helm/helm-gogs-local"
}
