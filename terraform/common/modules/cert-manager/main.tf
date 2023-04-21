terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "this" {
  name      = var.helm_chart_release_name
  namespace = kubernetes_namespace.this.metadata[0].name

  repository = var.helm_chart_repo
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [
    yamlencode(var.settings)
  ]

  dynamic "set" {
    for_each = {
      installCRDs = true
    }
    content {
      name  = set.key
      value = set.value
    }
  }
  depends_on = [
    kubernetes_namespace.this,
  ]
}

variable "selfsigned" {
  type    = bool
  default = true
}

resource "kubectl_manifest" "selfsigned_cluster_issuer" {
  count     = var.selfsigned ? 1 : 0
  yaml_body = <<-EOF
    apiVersion: "cert-manager.io/v1"
    kind: "ClusterIssuer"
    metadata:
      name: "${var.name}-selfsigned-cluster-issuer"
    spec:
      selfSigned: {}
    EOF

  depends_on = [
    kubernetes_namespace.this,
    helm_release.this,
  ]
}

resource "kubectl_manifest" "letsencrypt_cluster_issuer" {
  count     = var.selfsigned ? 0 : 1
  yaml_body = <<-EOF
    apiVersion: "cert-manager.io/v1"
    kind: "ClusterIssuer"
    metadata:
      name: "${var.name}-letsencrypt-cluster-issuer"
    spec:
      acme:
        email: "${var.email}"
        privateKeySecretRef:
          name: "letsencrypt-private-key"
        server: "https://acme-v02.api.letsencrypt.org/directory"
        solvers:
        - http01:
            ingress:
              class: nginx
          selector: {}
    EOF

  depends_on = [
    kubernetes_namespace.this,
    helm_release.this,
  ]
}

resource "kubectl_manifest" "certificate" {
  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata   = {
      name      = "${var.name}-certificate"
      namespace = kubernetes_namespace.this.metadata[0].name
    }
    spec = {
      dnsNames = [
        var.zone_name,
        "*.${var.zone_name}",
      ]
    }
    secretName = var.tls_secret_name
    issuerRef  = {
      kind = "ClusterIssuer"
      name = var.selfsigned ? kubectl_manifest.selfsigned_cluster_issuer.name : kubectl_manifest.letsencrypt_cluster_issuer.name
    }
  })
}
