data "aws_secretsmanager_secret" "private_key" {
  name = "gcp-privatekey"
}

data "aws_secretsmanager_secret_version" "private_key" {
  secret_id = data.aws_secretsmanager_secret.private_key.id
}
variable "workspace_url" {
  description = "The AWS Grafana Workspace url"
  type        = string
}
variable "auth_key" {
  description = "auth api key"
  type        = string
}