resource "helm_release" "ingress_nginx" {
  name      = var.helm_chart_release_name
  namespace = var.namespace

  repository = var.helm_chart_repo
  chart      = var.helm_chart_name
  version    = var.helm_chart_version

  values = [
    jsonencode({
      controller = {
        metrics = {
          enabled = true
        }
        replicaCount   = var.replicas
        updateStrategy = {
          rollingUpdate = {
            maxUnavailable = 0
            maxSurge       = 1
          },
          type = "RollingUpdate"
        }
        service = {
          annotations = merge(
            {
              "service.beta.kubernetes.io/aws-load-balancer-name"            = var.load_balancer_name
              "service.beta.kubernetes.io/aws-load-balancer-type"            = "nlb"
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
          use-proxy-protocol = "true"
          enable-real-ip     = "true"
          real-ip-header     = "proxy_protocol"
          proxy-real-ip-cidr = var.vpc_cidr_block

          server-tokens          = "false"
          hide-headers           = "Server, X-Powered-By"
          log-format-escape-json = "true"
          log-format-upstream    = "{\"time\": \"$time_iso8601\", \"request_id\": \"$request_id\", \"user\": \"$remote_user\", \"address\": \"$remote_addr\", \"connection_from\": \"$realip_remote_addr\", \"bytes_received\": $request_length, \"bytes_sent\": $bytes_sent, \"protocol\": \"$server_protocol\", \"scheme\": \"$scheme\", \"method\": \"$request_method\", \"host\": \"$host\", \"path\": \"$uri\", \"request_query\": \"$args\", \"referrer\": \"$http_referer\", \"user_agent\": \"$http_user_agent\", \"request_time\": $request_time, \"status\": $status, \"content_type\": \"$content_type\", \"upstream_response_time\": $upstream_response_time, \"namespace\": \"$namespace\", \"ingress\": \"$ingress_name\", \"service\": \"$service_name\", \"service_port\": \"$service_port\", \"vhost\": \"$server_name\", \"location\": \"$location_path\", \"nginx_upstream_addr\": \"$upstream_addr\", \"nginx_upstream_bytes_received\": \"$upstream_bytes_received\", \"nginx_upstream_response_time\": \"$upstream_response_time\", \"nginx_upstream_status\": \"$upstream_status\"}"
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
