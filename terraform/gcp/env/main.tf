resource "random_password" "postgresql_password" {
  count            = var.postgresql_password == null ? 1 : 0
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_password" "redis_password" {
  count            = var.redis_password == null ? 1 : 0
  length           = 16
  special          = true
  override_special = "_%@"
}

locals {
  # Name prefix will be used infront of every resource name.
  name_prefix = format("%s-%s", var.environment, var.name)

  # Common Tags to attach all the resources.
  tags = {
    "Environment"   = var.environment
    "resource-name" = var.name
    "project-id"    = var.project_id
  }

  postgresql_password = var.postgresql_password == null ? random_password.postgresql_password[0].result : var.postgresql_password
  redis_password      = var.redis_password == null ? random_password.redis_password[0].result : var.redis_password
}


module "vpc" {
  source = "../modules/vpc"

  name        = local.name_prefix
  environment = var.environment
  region      = var.region
  project_id  = var.project_id
  #  public_cidr_block  = var.public_cidr_block
  #  private_cidr_block = var.private_cidr_block
  #  tags               = local.tags
}

module "gke" {
  source             = "../modules/gke"
  environment        = var.environment
  name               = local.name_prefix
  region             = var.region
  project_id         = var.project_id
  initial_node_count = var.desired_capacity
  min_node_count     = var.min_size
  max_node_count     = var.max_size
  machine_type       = var.instance_type
  preemptible_nodes  = var.gke_preemptible_nodes
  spot_nodes         = var.gke_spot_nodes
  network_link       = module.vpc.network_selflink
  subnetwork_link    = module.vpc.subnetwork_selflink
  service_account    = module.iam.service_account
}

module "iam" {
  source                           = "../modules/iam"
  name                             = local.name_prefix
  region                           = var.region
  project_id                       = var.project_id
  service_account_custom_iam_roles = var.service_account_custom_iam_roles
  service_account_iam_roles        = var.service_account_iam_roles
  project_services                 = var.project_services
}

module "nic" {
  source = "../../common/modules/nginx-ingress-controller"

  helm_chart_release_name = format("%s-ingress-nginx", local.name_prefix)
  namespace               = var.ingress_namespace

  depends_on = [
    module.gke,
  ]
}

module "nic-lb-data" {
  source = "../modules/nginx-ingress-controller-loadbalancer-data"

  helm_chart_release_name = format("%s-ingress-nginx", local.name_prefix)
  namespace               = var.ingress_namespace

  depends_on = [
    module.nic,
  ]
}

module "cert-manager" {
  source = "../../common/modules/cert-manager"

  helm_chart_release_name = format("%s-cert-manager", local.name_prefix)
  namespace               = "cert-manager"
  email                   = var.lets_encrypt_email
  selfsigned              = true

  depends_on = [
    module.gke,
  ]
}

module "label-studio" {
  source = "../../common/modules/label-studio"

  name                     = local.name_prefix
  namespace                = "labelstudio"
  environment              = var.environment
  helm_chart_release_name  = format("%s-label-studio", local.name_prefix)
  helm_chart_repo          = var.label_studio_helm_chart_repo
  helm_chart_repo_username = var.label_studio_helm_chart_repo_username
  helm_chart_repo_password = var.label_studio_helm_chart_repo_password
  helm_chart_name          = var.label_studio_helm_chart_name
  helm_chart_version       = var.label_studio_helm_chart_version
  docker_registry_server   = var.label_studio_docker_registry_server
  docker_registry_username = var.label_studio_docker_registry_username
  docker_registry_email    = var.label_studio_docker_registry_email
  docker_registry_password = var.label_studio_docker_registry_password
  license_literal          = var.license_literal
  additional_set           = var.label_studio_additional_set
  enterprise               = var.enterprise
  cloud_provider           = "gcp"

  persistence_type = "disabled"

  postgresql_type         = var.postgresql_type
  postgresql_host         = var.postgresql_host
  postgresql_port         = var.postgresql_port
  postgresql_database     = var.postgresql_database
  postgresql_username     = var.postgresql_username
  postgresql_password     = local.postgresql_password
  postgresql_ssl_mode     = var.postgresql_ssl_mode
  postgresql_tls_key_file = var.postgresql_tls_key_file
  postgresql_tls_crt_file = var.postgresql_tls_crt_file
  postgresql_ca_crt_file  = var.postgresql_ca_crt_file

  redis_type         = var.enterprise ? var.redis_type : "absent"
  redis_host         = var.redis_host
  redis_password     = local.redis_password
  redis_ssl_mode     = var.redis_ssl_mode
  redis_tls_key_file = var.redis_tls_key_file
  redis_tls_crt_file = var.redis_tls_crt_file
  redis_ca_crt_file  = var.redis_ca_crt_file

  host                    = try(format("%s.nip.io", module.nic-lb-data.ip), "")
  certificate_issuer_name = try(module.cert-manager.issuer_name, "")

  depends_on = [
    module.gke,
    module.cert-manager,
    module.nic,
  ]
}
