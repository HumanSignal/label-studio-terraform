output "connect_cluster" {
  description = "Configuring EKS cluster access for kubectl"
  value       = format("gcloud container clusters get-credentials %s --region %s --project %s", module.gke.cluster_name, var.region, var.project_id)
}
