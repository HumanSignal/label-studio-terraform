# Name of the EKS cluster
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.id
}

# Version of the EKS cluster
output "cluster_version" {
  description = "Version of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.version
}

# The endpoint for your EKS Kubernetes API
output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

# AWS EKS IAM OIDC provider
output "iam_oidc_provider" {
  description = "AWS EKS IRSA id"
  value       = aws_iam_openid_connect_provider.aws_iam_openid_connect_provider
}

output "iam_oidc_provider_arn" {
  description = "AWS EKS IRSA arn"
  value       = aws_iam_openid_connect_provider.aws_iam_openid_connect_provider.arn
}

output "iam_oidc_provider_url" {
  description = "AWS EKS IRSA url"
  value       = aws_iam_openid_connect_provider.aws_iam_openid_connect_provider.url
}

# Output attributes of the Security Groups.
output "security_group_id" {
  description = "AWS EKS cluster security group"
  value = aws_security_group.security_group.id
}

output "worker_security_group_id" {
  description = "AWS EKS cluster communication security group"
  value = aws_security_group.worker_security_group.id
}
