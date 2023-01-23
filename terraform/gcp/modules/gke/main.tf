# Google container cluster(GKE) configuration
resource "google_container_cluster" "container_cluster" {
  name                     = var.name
  project                  = var.project_id
  description              = format("%s-gke-cluster", var.name)
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  # VPC and Sub-network self links. 
  network    = var.network_link
  subnetwork = var.subnetwork_link

  master_auth {
    # Whether client certificate authorization is enabled for this cluster.
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # Private Cluster configuration
  private_cluster_config {
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
  }

  # Resource labels
  resource_labels = {
    environment = format("%s", var.environment)
  }

  # Creates Internal Load Balancer
  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  # Provisioner to connect the GEK cluster. 
  provisioner "local-exec" {
    command = format("gcloud container clusters get-credentials %s --region %s --project %s", google_container_cluster.container_cluster.name, google_container_cluster.container_cluster.location, var.project_id)
  }

}

# Google container node pool configuration
resource "google_container_node_pool" "container_node_pool" {
  name       = format("%s-node-pool", var.name)
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.container_cluster.name
  node_count = var.initial_node_count

  # Node configuration
  node_config {
    machine_type = var.machine_type
    preemptible  = var.preemptible_nodes
    spot         = var.spot_nodes
    disk_size_gb = var.node_disk_size_gb
    tags         = ["http", "ssh"]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    service_account = var.service_account
    oauth_scopes    = [
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  depends_on = [
    google_container_cluster.container_cluster
  ]
}
