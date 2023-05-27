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
  value       = var.predefined_s3_bucket == null ? module.s3[0].bucket_name : var.predefined_s3_bucket.name
}

output "connect_cluster" {
  description = "Configuring EKS cluster access for kubectl"
  value       = format("aws eks --region %s update-kubeconfig --name %s --alias %s", var.region, module.eks.cluster_name, module.eks.cluster_name)
}

output "load_balancer_host" {
  value = module.nic.load_balancer_dns_name
}

output "host" {
  value = var.deploy_label_studio ? module.label-studio[0].host : ""
}

output "redis_host" {
  value = var.redis_type == "elasticache" && var.enterprise ? "rediss://${module.elasticache[0].host}:${module.elasticache[0].port}/1" : var.redis_host
}

output "redis_password" {
  sensitive = true
  value     = var.redis_type == "elasticache" && var.enterprise ? module.elasticache[0].password : local.redis_password
}

output "postgresql_host" {
  value = var.postgresql_type == "rds" ? module.rds[0].host : var.postgresql_host
}

output "postgresql_password" {
  sensitive = true
  value     = var.postgresql_type == "rds" ? module.rds[0].password : local.postgresql_password
}
