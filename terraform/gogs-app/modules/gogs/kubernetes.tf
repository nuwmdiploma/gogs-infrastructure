resource "kubernetes_namespace" "gogs-app" {
  metadata {
    annotations = {
      name = "gogs-app"
    }

    labels = {
      namespace = "gogs-app"
    }
    name = "gogs-app"
  }
  depends_on = [google_container_node_pool.gogs_node_pool]
  timeouts {
    delete = "1m"
  }
}

resource "kubernetes_secret" "gogs_docker_auth" {
  metadata {
    name      = "jfrogcred"
    namespace = kubernetes_namespace.gogs-app.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = (jsonencode({
      "auths" = {
        "${var.jfrog_registry}" = {
          "username" = var.jfrog_username,
          "password" = var.jfrog_password,
          "email"    = var.jfrog_email,
          "auth"     = base64encode("${var.jfrog_username}:${var.jfrog_password}")
        }
      }
    }))
  }
}