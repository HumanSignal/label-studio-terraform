data "kubernetes_service" "nginx-ingress-service" {
  metadata {
    name      = format("%s-controller", var.helm_chart_release_name)
    namespace = var.namespace
  }
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
    data.kubernetes_service.nginx-ingress-service,
  ]
}
