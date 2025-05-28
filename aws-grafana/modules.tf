module "workspace" {
  source = "./modules/workspace"
}

module "dashboard" {
    source = "./modules/dashboard"
    workspace_url = module.workspace.grafana_workspace_url
    auth_key = module.workspace.api-key
    
}