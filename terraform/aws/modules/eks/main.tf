# Elastic Kubernetes Service Cluster configuration
#tfsec:ignore:aws-eks-no-public-cluster-access tfsec:ignore:aws-eks-no-public-cluster-access-to-cidr tfsec:ignore:aws-eks-enable-control-plane-logging
resource "aws_kms_key" "eks" {
  description             = format("KMS key for %s-eks-cluster secrets", var.name)
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days = 10
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = format("%s-eks-cluster", var.name)
  role_arn = var.role_arn
  version  = var.cluster_version

  vpc_config {
    security_group_ids = [var.security_group_id]
    subnet_ids         = var.subnet_ids
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
