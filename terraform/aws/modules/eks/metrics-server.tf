module "helm" {
  count                   = var.metrics_server_enabled ? 1 : 0
  source                  = "../../../common/modules/metrics-server"
  helm_chart_release_name = format("%s-metrics-server", var.name)
  environment             = var.environment
  namespace               = var.monitoring_namespace

  depends_on = [
    aws_eks_node_group.eks_node_group,
  ]
}