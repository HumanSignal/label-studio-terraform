data "kubernetes_service" "nginx-ingress-service" {
  metadata {
    name      = format("%s-controller", var.helm_chart_release_name)
    namespace = var.namespace
  }
}
