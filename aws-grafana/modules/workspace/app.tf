resource "aws_grafana_workspace" "example" {
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  role_arn                 = aws_iam_role.assume.arn
}

resource "aws_iam_role" "assume" {
  name = "grafana-assume"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_grafana_role_association" "role" {
  role         = "ADMIN"
  user_ids     = [data.aws_identitystore_user.selected_user.id]
  workspace_id = aws_grafana_workspace.example.id
}

resource "aws_grafana_workspace_api_key" "key" {
  key_name        = "test-key"
  key_role        = "ADMIN"
  seconds_to_live = 3600
  workspace_id    = aws_grafana_workspace.example.id
}
