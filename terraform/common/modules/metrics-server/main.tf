resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "metrics_server" {
  name      = var.helm_chart_release_name
  namespace = var.namespace

  repository = var.helm_chart_repo
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [
    jsonencode({
      extraArgs = [
        "--kubelet-insecure-tls=true",
        "--kubelet-preferred-address-types=InternalIP"
      ]
      apiService = {
        create = true
      }
    }),
    jsonencode(var.helm_values),
  ]

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}
