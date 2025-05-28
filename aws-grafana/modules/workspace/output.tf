output "aws_grafana_workspace_value" {
  value     = aws_grafana_workspace.example.id
}
output "grafana_workspace_url" {
  value = "https://${aws_grafana_workspace.example.endpoint}"
}
output "api-key" {
  value = aws_grafana_workspace_api_key.key.key
  sensitive = true
}