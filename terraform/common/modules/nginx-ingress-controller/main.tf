resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "this" {
  name      = var.helm_chart_release_name
  namespace = var.namespace

  repository = var.helm_chart_repo
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [
    yamlencode(
      merge(
        {
          controller : {
            service : {
              annotations : {
                "service.beta.kubernetes.io/aws-load-balancer-name" : var.load_balancer_name
                "service.beta.kubernetes.io/aws-load-balancer-type" : "external"
                "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internet-facing"
                "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" : "ip"
                "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol": "*"
              }
            },
            config : {
              server-tokens: "false"
              enable-real-ip: "true"
              use-forwarded-headers: "true"
              use-proxy-protocol: "true"
              real-ip-header: "proxy_protocol"
            }
          }
        },
        var.settings,
      )
    )
  ]

  depends_on = [
    kubernetes_namespace.this
  ]
}
