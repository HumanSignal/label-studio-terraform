terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
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

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "heartex_pull_key" {
  metadata {
    name      = local.heartex_pull_key_secret_name
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  type = "kubernetes.io/dockerconfigjson"
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        (var.docker_registry_server) = {
          "username" = var.docker_registry_username
          "password" = var.docker_registry_password
          "email"    = var.docker_registry_email
          "auth"     = base64encode("${var.docker_registry_username}:${var.docker_registry_password}")
        }
      }
    })
  }
}

resource "kubernetes_secret" "license" {
  count = var.enterprise ? 1 : 0
  metadata {
    name      = local.license_secret_name
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  type = "generic"
  # TODO: Read license from file
  data = {
    (local.license_secret_key) = var.license_literal
  }
}

resource "kubernetes_secret" "postgresql" {
  count = contains(["external", "rds"], var.postgresql_type) ? 1 : 0
  metadata {
    name      = local.postgresql_secret_name
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  type = "generic"
  data = {
    (local.postgresql_secret_key) = var.postgresql_password
  }
}

resource "kubernetes_secret" "redis" {
  count = contains(["external", "elasticache"], var.redis_type) ? 1 : 0
  metadata {
    name      = local.redis_secret_name
    namespace = kubernetes_namespace.this.metadata[0].name
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
      namespace: "${kubernetes_namespace.this.metadata[0].name}"
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
  name      = var.helm_chart_release_name
  namespace = kubernetes_namespace.this.metadata[0].name

  repository          = var.helm_chart_repo
  repository_username = var.helm_chart_repo_username
  repository_password = var.helm_chart_repo_password
  chart               = var.helm_chart_name
  version             = var.helm_chart_version

  timeout = 900
  wait    = true

  dynamic set {
    for_each = merge(
      {
        "global.imagePullSecrets[0].name"                                          = kubernetes_secret.heartex_pull_key.metadata[0].name
        "enterprise.enabled"                                                       = var.enterprise
        "deployment_type"                                                          = "terraform"
        "cloud_provider"                                                           = var.cloud_provider
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
      # persistence
      tomap({
        "global.persistence.enabled"                                         = true
        "global.persistence.type"                                            = "s3"
        "global.persistence.config.s3.bucket"                                = var.persistence_s3_bucket_name
        "global.persistence.config.s3.region"                                = var.persistence_s3_bucket_region
        "global.persistence.config.s3.folder"                                = var.persistence_s3_bucket_folder
        "app.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"      = var.persistence_s3_role_arn
        "rqworker.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = var.persistence_s3_role_arn
      }),
      # postgres
      contains(["external", "rds"], var.postgresql_type) ? tomap({
        "postgresql.enabled"                  = false
        "global.pgConfig.host"                = var.postgresql_host
        "global.pgConfig.port"                = var.postgresql_port
        "global.pgConfig.dbName"              = var.postgresql_database
        "global.pgConfig.userName"            = var.postgresql_username
        "global.pgConfig.password.secretName" = kubernetes_secret.postgresql[0].metadata[0].name
        "global.pgConfig.password.secretKey"  = local.postgresql_secret_key
        # TODO: Add postgresql SSL configuration
      }) : tomap({
        "postgresql.enabled"                         = true
        "postgresql.auth.database"                   = var.postgresql_database
        "postgresql.auth.username"                   = var.postgresql_username
        "postgresql.tls.enabled"                     = true
        "postgresql.tls.autoGenerated"               = true
        "global.pgConfig.ssl.pgSslMode"              = "verify-full"
        "global.pgConfig.ssl.pgSslSecretName"        = "${var.helm_chart_release_name}-postgresql-crt"
        "global.pgConfig.ssl.pgSslRootCertSecretKey" = "ca.crt"
        "global.pgConfig.ssl.pgSslCertSecretKey"     = "tls.crt"
        "global.pgConfig.ssl.pgSslKeySecretKey"      = "tls.key"
      }),
      # redis
      contains(["internal"], var.redis_type) ? tomap({
        "redis.enabled"      = true
        "redis.auth.enabled" = true
      }) : tomap({
        "redis.enabled" = false
      }),
      contains(["external", "elasticache"], var.redis_type) ? tomap({
        "global.redisConfig.host"                = var.redis_host
        "global.redisConfig.password.secretName" = kubernetes_secret.redis[0].metadata[0].name
        "global.redisConfig.password.secretKey"  = local.redis_secret_key
        # TODO: Add redis SSL configuration
      }) : tomap({}),
      var.additional_set
    )
    content {
      name  = set.key
      value = set.value
    }
  }

  dynamic "set_sensitive" {
    for_each = merge(
      contains(["external", "rds"], var.postgresql_type) ? tomap({
      }) : tomap({
        "postgresql.auth.password" = var.postgresql_password
      }),
      contains(["internal"], var.redis_type) ? tomap({
        "redis.auth.password" = var.redis_password
      }) : tomap({}),
    )
    content {
      name  = set_sensitive.key
      value = set_sensitive.value
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
