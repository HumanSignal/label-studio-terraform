resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "this" {
  name = var.helm_chart_release_name

  repository = var.helm_chart_repo
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  namespace = var.namespace

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
locals {
  selfsigned_issuer_specs = { selfSigned = {} }
  acme_issuer_specs       = {
    acme = {
      email               = var.email
      privateKeySecretRef = {
        name = "letsencrypt-cluster-issuer-key"
      }
      server  = "https://acme-v02.api.letsencrypt.org/directory"
      solvers = [
        {
          http01 = {
            ingress = {
              class = "nginx"
            }
          }
        }
      ]
    }
  }
}

terraform {
  required_providers {
     kubectl = {
      source  = "gavinbunney/kubectl"
   }
  }
}

resource "kubectl_manifest" "clusterissuer_letsencrypt" {
  yaml_body = <<-EOF
    apiVersion: "cert-manager.io/v1"
    kind: "ClusterIssuer"
    metadata:
      name: "letsencrypt-cluster-issuer"
    spec:
      selfSigned: {}
    EOF
  #    spec = (var.selfsigned ? local.selfsigned_issuer_specs : local.acme_issuer_specs)

  depends_on = [
    kubernetes_namespace.this,
    helm_release.this,
  ]
}
