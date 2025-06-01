resource "helm_release" "gogs-app" {
  name                = "gogs-app"
  repository          = var.helm_repo
  chart               = "gogsapp"
  namespace           = kubernetes_namespace.gogs-app.metadata[0].name
  depends_on          = [kubernetes_namespace.gogs-app]
  timeout             = 600
  repository_username = var.jfrog_username
  repository_password = var.jfrog_password

  set {
    name  = "env"
    value = var.env
  }
  set {
    name  = "ingress.env[0].name"
    value = "envd"
  }
  set {
    name  = "service.targetPort"
    value = 3000
  }
  set {
    name  = "service.port"
    value = 3000
  }
  set {
    name  = "image.registry"
    value = var.jfrog_registry
  }
  set {
    name  = "image.repository"
    value = var.jfrog_repository
  }
  set {
    name  = "image.tag"
    value = var.gogs_build_tag
  }
  set {
    name  = "service.env[0].name"
    value = "MYSQL_DATABASE"
  }
  set {
    name  = "service.env[0].value"
    value = var.mysql_db_name
  }
  set {
    name  = "service.env[1].name"
    value = "MYSQL_ROOT_PASSWORD"
  }
  set {
    name  = "service.env[1].value"
    value = kubernetes_secret.gogs_admin_password.data.password
  }
  set {
    name  = "service.env[2].name"
    value = "MYSQL_USER"
  }
  set {
    name  = "service.env[2].value"
    value = var.mysql_username
  }
  set {
    name  = "service.env[3].name"
    value = "MYSQL_PASSWORD"
  }
  set {
    name  = "service.env[3].value"
    value = kubernetes_secret.gogs_admin_password.data.password
  }

  set {
    name  = "mysql.auth.username"
    value = var.mysql_username
  }
  set {
    name  = "mysql.auth.password"
    value = kubernetes_secret.gogs_admin_password.data.password
  }
  set {
    name  = "mysql.auth.database"
    value = var.mysql_db_name
  }
}