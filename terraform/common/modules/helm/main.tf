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

  wait = true
  
  dynamic set {
    for_each = {
      "global.imagePullSecrets[0].name"                                                            = kubernetes_secret.heartex_pull_key.metadata[0].name
      "global.enterpriseLicense.secretName"                                                        = kubernetes_secret.license.metadata[0].name
      "global.enterpriseLicense.secretKey"                                                         = var.license_secret_key
      "ci"                                                                                         = true # TODO: Remove
      "postgresql.enabled"                                                                         = true
      "redis.enabled"                                                                              = true
      "minio.enabled"                                                                              = false
      "app.ingress.enabled"                                                                        = false
      "app.service.type"                                                                           = "LoadBalancer"
      "app.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"            = "external"
      "app.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type" = "ip"
      "app.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"          = "internet-facing"
    }
    content {
      name  = set.key
      value = set.value
    }
  }

  dynamic set {
    for_each = var.additional_set
    content {
      name  = set.key
      value = set.value
    }
  }
}
