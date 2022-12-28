terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

locals {
  heartex_pull_key_secret_name    = "heartex-pull-key"
  license_secret_name             = "lse-license"
  license_secret_key              = "license"
  postgresql_secret_name          = "postgresql"
  postgresql_secret_key           = "password"
  postgresql_ssl_enabled          = var.postgresql_type == "external" && var.postgresql_ca_crt_file != null && var.postgresql_tls_crt_file != null && var.postgresql_tls_key_file != null
  postgresql_ssl_cert_secret_name = "${var.helm_chart_release_name}-postgresql-crt"
  postgresql_ca_crt_secret_key    = "ca.crt"
  postgresql_tls_crt_secret_key   = "tls.crt"
  postgresql_tls_key_secret_key   = "tls.key"
  redis_secret_name               = "redis"
  redis_secret_key                = "password"
  redis_ssl_enabled               = var.redis_type == "external" && var.redis_ca_crt_file != null && var.redis_tls_crt_file != null && var.redis_tls_key_file != null
  redis_ssl_cert_secret_name      = "${var.helm_chart_release_name}-redis-crt"
  redis_ca_crt_secret_key         = "ca.crt"
  redis_tls_crt_secret_key        = "tls.crt"
  redis_tls_key_secret_key        = "tls.key"
  tls_secret_name                 = "tls"
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

resource "kubernetes_secret" "postgresql-ssl-cert" {
  count = local.postgresql_ssl_enabled ? 1 : 0
  metadata {
    name      = local.postgresql_ssl_cert_secret_name
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  type = "kubernetes.io/tls"
  data = {
    (local.postgresql_ca_crt_secret_key)  = file(var.postgresql_ca_crt_file)
    (local.postgresql_tls_crt_secret_key) = file(var.postgresql_tls_crt_file)
    (local.postgresql_tls_key_secret_key) = file(var.postgresql_tls_key_file)
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

resource "kubernetes_secret" "redis-ssl-cert" {
  count = local.redis_ssl_enabled ? 1 : 0
  metadata {
    name      = local.redis_ssl_cert_secret_name
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  type = "kubernetes.io/tls"
  data = {
    (local.redis_ca_crt_secret_key)  = file(var.redis_ca_crt_file)
    (local.redis_tls_crt_secret_key) = file(var.redis_tls_crt_file)
    (local.redis_tls_key_secret_key) = file(var.redis_tls_key_file)
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
      var.postgresql_type == "internal" ? tomap({
        "postgresql.enabled"                         = true
        "postgresql.auth.database"                   = var.postgresql_database
        "postgresql.auth.username"                   = var.postgresql_username
        "postgresql.tls.enabled"                     = true
        "postgresql.tls.autoGenerated"               = true
        "global.pgConfig.ssl.pgSslMode"              = "verify-full"
        "global.pgConfig.ssl.pgSslSecretName"        = local.postgresql_ssl_cert_secret_name
        "global.pgConfig.ssl.pgSslRootCertSecretKey" = local.postgresql_ca_crt_secret_key
        "global.pgConfig.ssl.pgSslCertSecretKey"     = local.postgresql_tls_crt_secret_key
        "global.pgConfig.ssl.pgSslKeySecretKey"      = local.postgresql_tls_key_secret_key
      }) : tomap({}),
      var.postgresql_type == "external" ? tomap({
        "postgresql.enabled"                  = false
        "global.pgConfig.host"                = var.postgresql_host
        "global.pgConfig.port"                = var.postgresql_port
        "global.pgConfig.dbName"              = var.postgresql_database
        "global.pgConfig.userName"            = var.postgresql_username
        "global.pgConfig.password.secretName" = kubernetes_secret.postgresql[0].metadata[0].name
        "global.pgConfig.password.secretKey"  = local.postgresql_secret_key
      }) : tomap({}),
      var.postgresql_type == "external" && local.postgresql_ssl_enabled ? tomap({
        "global.pgConfig.ssl.pgSslMode"              = var.postgresql_ssl_mode
        "global.pgConfig.ssl.pgSslSecretName"        = kubernetes_secret.postgresql-ssl-cert[0].metadata[0].name
        "global.pgConfig.ssl.pgSslRootCertSecretKey" = local.postgresql_ca_crt_secret_key
        "global.pgConfig.ssl.pgSslCertSecretKey"     = local.postgresql_tls_crt_secret_key
        "global.pgConfig.ssl.pgSslKeySecretKey"      = local.postgresql_tls_key_secret_key
      }) : tomap({}),
      var.postgresql_type == "rds" ? tomap({
        "postgresql.enabled"                  = false
        "global.pgConfig.host"                = var.postgresql_host
        "global.pgConfig.port"                = var.postgresql_port
        "global.pgConfig.dbName"              = var.postgresql_database
        "global.pgConfig.userName"            = var.postgresql_username
        "global.pgConfig.password.secretName" = kubernetes_secret.postgresql[0].metadata[0].name
        "global.pgConfig.password.secretKey"  = local.postgresql_secret_key
        "global.pgConfig.ssl.pgSslMode"       = "require"
      }) : tomap({}),
      # redis
      var.redis_type == "internal" ? tomap({
        "redis.enabled"                                    = true
        "redis.auth.enabled"                               = true
        "redis.tls.enabled"                                = true
        "redis.tls.autoGenerated"                          = true
        "global.redisConfig.ssl.redisSslCertReqs"          = "required"
        "global.redisConfig.ssl.redisSslSecretName"        = local.redis_ssl_cert_secret_name
        "global.redisConfig.ssl.redisSslCaCertsSecretKey"  = local.redis_ca_crt_secret_key
        "global.redisConfig.ssl.redisSslCertFileSecretKey" = local.redis_tls_crt_secret_key
        "global.redisConfig.ssl.redisSslKeyFileSecretKey"  = local.redis_tls_key_secret_key
      }) : tomap({}),
      var.redis_type == "external" ? tomap({
        "redis.enabled"                          = false
        "global.redisConfig.host"                = var.redis_host
        "global.redisConfig.password.secretName" = kubernetes_secret.redis[0].metadata[0].name
        "global.redisConfig.password.secretKey"  = local.redis_secret_key
      }) : tomap({}),
      var.redis_type == "external" && local.redis_ssl_enabled ? tomap({
        "global.redisConfig.ssl.redisSslCertReqs"          = var.redis_ssl_mode
        "global.redisConfig.ssl.redisSslSecretName"        = kubernetes_secret.redis-ssl-cert[0].metadata[0].name
        "global.redisConfig.ssl.redisSslCaCertsSecretKey"  = local.redis_ca_crt_secret_key
        "global.redisConfig.ssl.redisSslCertFileSecretKey" = local.redis_tls_crt_secret_key
        "global.redisConfig.ssl.redisSslKeyFileSecretKey"  = local.redis_tls_key_secret_key
      }) : tomap({}),
      var.redis_type == "elasticache" ? tomap({
        "redis.enabled"                           = false
        "global.redisConfig.host"                 = var.redis_host
        "global.redisConfig.password.secretName"  = kubernetes_secret.redis[0].metadata[0].name
        "global.redisConfig.password.secretKey"   = local.redis_secret_key
        "global.redisConfig.ssl.redisSslCertReqs" = "required"
      }) : tomap({}),
      var.redis_type == "absent" ? tomap({
        "redis.enabled" = false
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
    kubernetes_secret.postgresql-ssl-cert,
    kubernetes_secret.redis,
    kubernetes_secret.redis-ssl-cert,
    kubernetes_secret.license,
    kubectl_manifest.certificate,
    kubernetes_secret.heartex_pull_key,
  ]
}
