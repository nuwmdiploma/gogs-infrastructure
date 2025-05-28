terraform {
  source = "../../../modules/tf_state"

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

inputs = {
    env = "dev-01"
    region = "europe-west4"
    project = "capybara-dev-42069"
}