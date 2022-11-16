resource "helm_release" "metrics_server" {
  count = var.enabled

  name = var.helm_release_name

  repository = var.helm_chart_repo
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  namespace = var.namespace

  values = [
    yamlencode(var.settings)
  ]
}