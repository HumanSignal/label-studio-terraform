output "network_selflink" {
  description = "variable for the vpc network selflink"
  value       = google_compute_network.compute_network.self_link
}

output "subnetwork_selflink" {
  description = "variable for the subnetwork selflink"
  value       = google_compute_subnetwork.compute_subnetwork.self_link
}
