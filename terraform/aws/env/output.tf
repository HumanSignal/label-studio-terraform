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

output "dns" {
  value = local.create_r53_record ? module.route53[0].fqdn : ""
}
