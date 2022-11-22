output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_version" {
  description = "Version of the EKS cluster"
  value       = module.eks.cluster_version
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API"
  value       = module.eks.cluster_endpoint
}

output "bucket_id" {
  description = "Bucket Name (aka ID)"
  value       = module.s3.bucket_id
}

output "connect_cluster" {
  description = "Configuring EKS cluster access for kubectl"
  value       = format("aws eks --region %s update-kubeconfig --name %s --alias %s", var.region, module.eks.cluster_name, module.eks.cluster_name)
}

output "host" {
  value = module.nic.host
}
