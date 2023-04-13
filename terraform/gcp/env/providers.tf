provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.gke.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.gke.access_token
}

provider "kubectl" {
  host                   = "https://${data.google_container_cluster.gke.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.gke.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.gke.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.gke.access_token
  }

  ## Doesn't work with alb-ingress-controller manifest
  #  experiments {
  #    manifest = true
  #  }
}

provider "random" {
}

data "google_container_cluster" "gke" {
  name       = module.gke.cluster_name
  location   = module.gke.cluster_location
  depends_on = [module.gke]
}

data "google_client_config" "gke" {
  depends_on = [data.google_container_cluster.gke]
}
