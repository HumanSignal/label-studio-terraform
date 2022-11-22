data "kubernetes_service" "nginx-ingress-service" {
  metadata {
    name      = format("%s-controller", var.helm_chart_release_name)
    namespace = var.namespace
  }
  depends_on = [
    helm_release.this
  ]
}

output "host" {
  value = data.kubernetes_service.nginx-ingress-service.status.0.load_balancer.0.ingress.0.hostname
}
