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
                "cloud.google.com/neg" : jsonencode(
                  {
                    exposed_ports : {
                      "80" : {
                        name : "ingress-nginx-controller-neg"
                      }
                    }
                  }
                )
              }
            }
          }
        },
        var.settings,
      )
    )
  ]
}
