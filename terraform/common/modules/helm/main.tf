resource "kubernetes_secret" "heartex_pull_key" {
  metadata {
    name = "heartex-pull-key"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        (var.registry_server) = {
          "username" = var.registry_username
          "password" = var.registry_password
          "email"    = var.registry_email
          "auth"     = base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }
}

resource "kubernetes_secret" "license" {
  metadata {
    name = "lse-license"
  }

  type = "generic"

  # TODO: Read license from file
  data = {
    (var.license_secret_key) = var.license_literal
  }
}

resource "helm_release" "label_studio" {
  name = "label-studio"

  repository = var.repository
  chart      = var.chart

  repository_username = var.repository_username
  repository_password = var.repository_password

  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.heartex_pull_key.metadata[0].name
  }

  set {
    name  = "global.enterpriseLicense.secretName"
    value = kubernetes_secret.license.metadata[0].name
  }
  set {
    name  = "global.enterpriseLicense.secretKey"
    value = var.license_secret_key
  }

  set {
    name  = "global.enterpriseLicense.secretName"
    value = "lse-license"
  }
  set {
    name  = "global.enterpriseLicense.secretKey"
    value = "license"
  }

  set {
    # TODO: remove
    name  = "ci"
    value = true
  }


  set {
    name  = "postgresql.enabled"
    value = true
  }

  set {
    name  = "redis.enabled"
    value = true
  }

}
