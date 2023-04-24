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
          controller = {
            service = {
              annotations = {
                "service.beta.kubernetes.io/aws-load-balancer-name"            = var.load_balancer_name
                "service.beta.kubernetes.io/aws-load-balancer-type"            = "external"
                "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
                "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
                "service.beta.kubernetes.io/aws-load-balancer-eip-allocations" = join(",", var.eip_addresses)
                "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol"  = "*"
              }
            },
            config = {
              server-tokens      = "false"
              enable-real-ip     = "true"
              use-proxy-protocol = "true"
              real-ip-header     = "proxy_protocol"
              set-real-ip-from   = "0.0.0.0/0" # IPv4 CIDR to allow all source IPs
              hide-headers       = "Server, X-Powered-By"
            },
            extraArgs = {
              default-ssl-certificate = var.default_ssl_certificate
            }
          }
        },
        var.settings,
      )
    )
  ]
}
