resource "helm_release" "this" {
  name = var.helm_chart_release_name

  repository = var.helm_chart_repo
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  namespace = var.namespace

  values = [
    yamlencode(var.settings)
  ]
}
