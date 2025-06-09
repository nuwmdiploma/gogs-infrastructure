resource "grafana_data_source" "example" {
  type = "stackdriver"
  name = "sd-arbitrary-data"

  json_data_encoded = jsonencode({
    "tokenUri"           = "https://oauth2.googleapis.com/token"
    "authenticationType" = "jwt"
    "defaultProject"     = "nuwmdiploma"
    "clientEmail"        = "gcp-grafana@nuwmdiploma.iam.gserviceaccount.com"
  })

  secure_json_data_encoded = jsonencode({
    "privateKey" = data.aws_secretsmanager_secret_version.private_key.secret_string
  })
}

resource "grafana_folder" "data" {
  title = "data"
}

resource "grafana_dashboard" "gcp-dashboard" {
  config_json = file("./modules/dashboard/gcp-dashboards/gcp-dashboard.json")
  folder      = grafana_folder.data.id
  overwrite   = true
}