resource "helm_release" "ingress_nginx" {
  name      = var.helm_chart_release_name
  namespace = var.namespace

  repository = var.helm_chart_repo
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [
    jsonencode({
      controller = {
        replicaCount   = var.replicas
        updateStrategy = {
          rollingUpdate = {
            maxUnavailable = 0
            maxSurge = 1
          },
          type = "RollingUpdate"
        }
        service = {
          annotations = merge(
            {
              "service.beta.kubernetes.io/aws-load-balancer-name"            = var.load_balancer_name
              "service.beta.kubernetes.io/aws-load-balancer-type"            = "external"
              "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
              "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "instance"
              "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol"  = "*"
            },
            var.eip_addresses != [] ? tomap({
              "service.beta.kubernetes.io/aws-load-balancer-eip-allocations" = join(",", var.eip_addresses)
            }) : {},
          )
        },
        config = {
          server-tokens      = "false"
          enable-real-ip     = "true"
          use-proxy-protocol = "true"
          real-ip-header     = "proxy_protocol"
          set-real-ip-from   = "0.0.0.0/0" # IPv4 CIDR to allow all source IPs
          hide-headers       = "Server, X-Powered-By"
        },
        extraArgs = merge(
          {},
          var.default_ssl_certificate != null ? tomap({
            default-ssl-certificate = var.default_ssl_certificate
          }) : {},
        )
        affinity = {
          podAntiAffinity = {
            preferredDuringSchedulingIgnoredDuringExecution = [
              {
                weight          = 100
                podAffinityTerm = {
                  labelSelector = {
                    matchExpressions = [
                      {
                        key      = "app.kubernetes.io/name"
                        operator = "In"
                        values   = ["ingress-nginx"]
                      },
                      {
                        key      = "app.kubernetes.io/instance"
                        operator = "In"
                        values   = [var.helm_chart_release_name]
                      },
                      {
                        key      = "app.kubernetes.io/component"
                        operator = "In"
                        values   = ["controller"]
                      },
                    ]
                  }
                  topologyKey = "kubernetes.io/hostname"
                }
              },
            ]
          }
        },
      }
    }),
    jsonencode(var.helm_values),
  ]
}
