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

  chart = var.chart

  atomic       = true
  timeout      = 900
  wait         = true
  force_update = true # TODO: Remove

  dynamic set {
    for_each = {
      "global.imagePullSecrets[0].name"                                                            = kubernetes_secret.heartex_pull_key.metadata[0].name
      "enterprise.enterpriseLicense.secretName"                                                    = kubernetes_secret.license.metadata[0].name
      "enterprise.enterpriseLicense.secretKey"                                                     = var.license_secret_key
      "ci"                                                                                         = true # TODO: Remove
      "postgresql.enabled"                                                                         = true
      "redis.enabled"                                                                              = true
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
