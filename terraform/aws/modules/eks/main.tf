resource "aws_kms_key" "eks" {
  description              = format("KMS key for %s-eks-cluster secrets", var.name)
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  deletion_window_in_days  = 10
}

# Elastic Kubernetes Service Cluster configuration
#tfsec:ignore:aws-eks-no-public-cluster-access tfsec:ignore:aws-eks-no-public-cluster-access-to-cidr tfsec:ignore:aws-eks-enable-control-plane-logging
resource "aws_eks_cluster" "eks_cluster" {
  name     = format("%s-eks-cluster", var.name)
  role_arn = var.role_arn
  version  = var.cluster_version

  vpc_config {
    security_group_ids      = [aws_security_group.security_group.id]
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  enabled_cluster_log_types = var.eks_cluster_enabled_log_types

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.eks.arn
    }
  }

  tags = var.tags

  provisioner "local-exec" {
    command = format("aws eks --region %s update-kubeconfig --name %s --alias %s", var.region, aws_eks_cluster.eks_cluster.name, aws_eks_cluster.eks_cluster.name)
  }

}

# AWS EKS node group configuration.
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = format("%s-eks-node-group", var.name)
  node_role_arn   = var.worker_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = [var.instance_type]

  capacity_type = var.capacity_type

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  tags = merge(
    var.tags,
    {
      "Name"                                                   = format("%s-eks-node-group", var.name)
      format("kubernetes.io/cluster/%s-eks-cluster", var.name) = "owned"
    },
  )

  labels = {
    "key" = format("%s", aws_eks_cluster.eks_cluster.name)
  }

  # Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

# aws-auth configmap
locals {
  aws_auth_configmap_data = {
    mapRoles    = yamlencode(
        concat(
            [{
                rolearn  = var.worker_role_arn
                username = "system:node:{{EC2PrivateDNSName}}"
                groups = ["system:bootstrappers","system:nodes"]
            }],
            var.aws_auth_roles
            )
        )
    mapUsers    = yamlencode(var.aws_auth_users)
    mapAccounts = yamlencode(var.aws_auth_accounts)
  }
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = local.aws_auth_configmap_data

  depends_on = [
    aws_eks_cluster.eks_cluster,
  ]
}
