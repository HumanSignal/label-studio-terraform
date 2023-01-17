# End point of the google container cluster.
output "endpoint" {
  description = "End point of the google container cluster"
  value       = google_container_cluster.container_cluster.endpoint
}

# Master version of Kubernetes cluster.
output "master_version" {
  description = "Master version of Kubernetes cluster"
  value       = google_container_cluster.container_cluster.master_version
}

# GKE cluster name.
output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.container_cluster.name
}

output "cluster_location" {
  value = google_container_cluster.container_cluster.location
}
