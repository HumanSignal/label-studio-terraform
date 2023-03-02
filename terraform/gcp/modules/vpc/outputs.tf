output "network_selflink" {
  description = "the vpc network selflink"
  value       = google_compute_network.compute_network.self_link
}

output "network_id" {
  description = "the vpc network id"
  value       = google_compute_network.compute_network.id
}

output "subnetwork_selflink" {
  description = "subnetwork selflink"
  value       = google_compute_subnetwork.compute_subnetwork.self_link
}

output "subnetwork_id" {
  description = "subnetwork id"
  value       = google_compute_subnetwork.compute_subnetwork.id
}

output "subnetwork_ip_cidr_range" {
  value = google_compute_subnetwork.compute_subnetwork.ip_cidr_range
}
