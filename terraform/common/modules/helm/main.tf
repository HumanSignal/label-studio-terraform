resource "helm_release" "label_studio" {
  name = "label-studio"

  repository = "https://charts.heartex.com"
  chart      = "label-studio-enterprise"

  repository_username = var.repository_username
  repository_password = var.repository_password

  set {
    name  = "global.enterpriseLicense.secretName"
    value = "lse-license"
  }
  set {
    name  = "global.enterpriseLicense.secretKey"
    value = "license"
  }

  set { # TODO: remove
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
