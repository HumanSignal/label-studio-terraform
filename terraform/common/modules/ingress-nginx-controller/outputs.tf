data "kubernetes_service" "ingress_nginx_service" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = var.namespace
  }

  depends_on = [
    helm_release.ingress_nginx,
  ]
}

data "aws_lb" "load_balancer" {
  name = join(
    "-",
    slice(
      split(
        "-",
        element(
          split(
            ".",
            data.kubernetes_service.ingress_nginx_service.status.0.load_balancer.0.ingress.0.hostname),
          0
        )
      ),
      0,
      length(
        split(
          "-",
          element(
            split(
              ".",
              data.kubernetes_service.ingress_nginx_service.status.0.load_balancer.0.ingress.0.hostname),
            0)
        )
      ) - 1
    )
  )
  depends_on = [
    helm_release.ingress_nginx,
    data.kubernetes_service.ingress_nginx_service,
  ]
}

output "host" {
  value = data.aws_lb.load_balancer.dns_name
}

output "load_balancer_name" {
  value = var.load_balancer_name
}

output "load_balancer_dns_name" {
  value = data.aws_lb.load_balancer.dns_name
}

output "load_balancer_zone_id" {
  value = data.aws_lb.load_balancer.zone_id
}
