terraform {
  required_providers {
     kubectl = {
      source  = "gavinbunney/kubectl"
   }
  }
}

locals {
  heartex_pull_key_secret_name = "heartex-pull-key"
  license_secret_name          = "lse-license"
  license_secret_key           = "license"
  postgresql_secret_name       = "postgresql"
  postgresql_secret_key        = "password"
  redis_secret_name            = "redis"
  redis_secret_key             = "password"
  tls_secret_name              = "tls"
}

resource "kubernetes_secret" "heartex_pull_key" {
  metadata {
    name = local.heartex_pull_key_secret_name
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
  count = var.enterprise ? 1 : 0
  metadata {
    name = local.license_secret_name
  }
  type = "generic"
  # TODO: Read license from file
  data = {
    (local.license_secret_key) = var.license_literal
  }
}

resource "kubernetes_secret" "postgresql" {
  count = var.postgresql == "rds" ? 1 : 0
  metadata {
    name = local.postgresql_secret_name
  }
  type = "generic"
  data = {
    (local.postgresql_secret_key) = var.postgresql_password
  }
}

resource "kubernetes_secret" "redis" {
  count = var.redis == "elasticache" ? 1 : 0
  metadata {
    name = local.redis_secret_name
  }
  type = "generic"
  data = {
    (local.redis_secret_key) = var.redis_password
  }
}

resource "kubectl_manifest" "certificate" {
  yaml_body = <<-EOF
    apiVersion: "cert-manager.io/v1"
    kind: "Certificate"
    metadata:
      name: "${var.name}-label-studio-certificate"
      namespace: "${var.namespace}"
    spec:
      dnsNames:
        - "${var.host}"
      secretName: "${local.tls_secret_name}"
      issuerRef:
        kind: "ClusterIssuer"
        name: "${var.certificate_issuer_name}"
    EOF
}

resource "helm_release" "label_studio" {
  name = format("%s-label-studio", var.name)

  chart = var.helm_chart_release_name

  timeout = 900
  wait    = true

  dynamic set {
    for_each = merge(
      {
        "global.imagePullSecrets[0].name"                                          = kubernetes_secret.heartex_pull_key.metadata[0].name
        "enterprise.enabled"                                                       = var.enterprise
        # TODO: Remove ci
        "ci"                                                                       = true
        "app.ingress.enabled"                                                      = true
        "app.ingress.className"                                                    = "nginx"
        "app.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/rewrite-target" = "/"
        "app.ingress.tls[0].secretName"                                            = local.tls_secret_name
        "app.ingress.tls[0].hosts[0]"                                              = var.host
        "app.ingress.host"                                                         = var.host
      },
      # licence
      var.enterprise ? tomap({
        "enterprise.enterpriseLicense.secretName" = kubernetes_secret.license[0].metadata[0].name
        "enterprise.enterpriseLicense.secretKey"  = local.license_secret_key
      }) : tomap({}),
      # postgres
      var.postgresql == "rds" ? tomap({
        "postgresql.enabled"                  = false
        "global.pgConfig.host"                = var.postgresql_host
        "global.pgConfig.port"                = var.postgresql_port
        "global.pgConfig.dbName"              = var.postgresql_database
        "global.pgConfig.userName"            = var.postgresql_username
        "global.pgConfig.password.secretName" = kubernetes_secret.postgresql[0].metadata[0].name
        "global.pgConfig.password.secretKey"  = local.postgresql_secret_key
        # TODO: Add postgresql SSL configuration
      }) : tomap({
        "postgresql.enabled"       = true
        "postgresql.auth.database" = var.postgresql_database
        "postgresql.auth.username" = var.postgresql_username
        "postgresql.auth.password" = var.postgresql_password
      }),
      # redis
      var.redis == "elasticache" ? tomap({
        "redis.enabled"                          = false
        "global.redisConfig.host"                = var.redis_host
        "global.redisConfig.password.secretName" = kubernetes_secret.redis[0].metadata[0].name
        "global.redisConfig.password.secretKey"  = local.redis_secret_key
        # TODO: Add redis SSL configuration
      }) : tomap({
        "redis.enabled" = true
      }),
      var.additional_set
    )
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [
    kubernetes_secret.postgresql,
    kubernetes_secret.redis,
    kubernetes_secret.license,
    kubectl_manifest.certificate,
    kubernetes_secret.heartex_pull_key,
  ]
}
