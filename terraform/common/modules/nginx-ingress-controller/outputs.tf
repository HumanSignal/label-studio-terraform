data "kubernetes_service" "nginx-ingress-service" {
  metadata {
    name      = format("%s-controller", var.helm_chart_release_name)
    namespace = var.namespace
  }

  depends_on = [
    helm_release.this,
  ]
}

data "aws_lb" "this" {
  name = join(
    "-",
    slice(
      split(
        "-",
        element(
          split(
            ".",
            data.kubernetes_service.nginx-ingress-service.status.0.load_balancer.0.ingress.0.hostname),
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
              data.kubernetes_service.nginx-ingress-service.status.0.load_balancer.0.ingress.0.hostname),
            0)
        )
      ) - 1
    )
  )
  depends_on = [
    helm_release.this,
    data.kubernetes_service.nginx-ingress-service,
  ]
}

output "host" {
  value = data.aws_lb.this.dns_name
}

output "load_balancer_name" {
  value = var.load_balancer_name
}

output "load_balancer_dns_name" {
  value = data.aws_lb.this.dns_name
}

output "load_balancer_zone_id" {
  value = data.aws_lb.this.zone_id
}
