# Create VPC
module "vpc" {
  source = "../modules/vpc"

  name               = local.name_prefix
  environment        = var.environment
  region             = var.region
  public_cidr_block  = var.public_cidr_block
  private_cidr_block = var.private_cidr_block
  tags               = local.tags
}

# Create Identity Access Management
module "iam" {
  source = "../modules/iam"

  name        = local.name_prefix
  region      = var.region
  environment = var.environment
  tags        = local.tags
  bucket_id   = module.s3.bucket_id
}

# Create S3 bucket
module "s3" {
  source = "../modules/s3"

  name        = local.name_prefix
  environment = var.environment
  tags        = local.tags
}

# Create Elastic Kubernetes Service
module "eks" {
  source = "../modules/eks"

  name                  = local.name_prefix
  region                = var.region
  environment           = var.environment
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  max_size              = var.max_size
  min_size              = var.min_size
  role_arn              = module.iam.role_arn
  worker_role_arn       = module.iam.worker_role_arn
  subnet_ids            = module.vpc.aws_subnet_private_ids
  security_group_id     = module.vpc.security_group_id
  public_subnets        = module.vpc.aws_subnet_public_ids
  instance_profile_name = module.iam.iam_instance_profile
  tags                  = local.tags
  capacity_type         = var.eks_capacity_type
}

module "route53" {
  source = "../modules/route53"

  count = local.create_r53_record ? 1 : 0

  create_r53_zone        = var.create_r53_zone
  record_name            = var.record_name
  domain_name            = var.domain_name
  tags                   = local.tags
  alias_name             = module.nic.host
  alias_zone_id          = var.region
  load_balancer_dns_name = module.nic.load_balancer_dns_name
  load_balancer_zone_id  = module.nic.load_balancer_zone_id
}

module "acm" {
  source = "../modules/acm"

  count = var.create_acm_certificate ? 1 : 0

  domain_name = var.domain_name
  tags        = local.tags
}

module "rds" {
  source = "../modules/rds"

  count = var.postgresql == "rds" ? 1 : 0

  name         = local.name_prefix
  environment  = var.environment
  vpc_id       = module.vpc.aws_vpc_id
  subnet_ids   = module.vpc.aws_subnet_private_ids
  machine_type = var.postgresql_machine_type
  database     = var.postgresql_database
  username     = var.postgresql_username
  password     = var.postgresql_password
  tags         = local.tags

  depends_on = [module.vpc]
}

module "elasticache" {
  source = "../modules/elasticache"

  count = var.redis == "elasticache" && var.enterprise ? 1 : 0

  name         = local.name_prefix
  vpc_id       = module.vpc.aws_vpc_id
  subnet_ids   = module.vpc.aws_subnet_private_ids
  machine_type = var.redis_machine_type
  port         = var.redis_port
  password     = var.redis_password
  tags         = local.tags

  depends_on = [module.vpc]
}

module "lbc" {
  source = "../modules/load-balancer-controller"

  name              = local.name_prefix
  environment       = var.environment
  cluster_name      = module.eks.cluster_name
  iam_oidc_provider = module.eks.iam_oidc_provider

  depends_on = [
    module.eks,
    module.vpc,
  ]
}

module "nic" {
  source = "../../common/modules/nginx-ingress-controller"

  helm_chart_release_name = format("%s-ingress-nginx", local.name_prefix)
  namespace               = "kube-system"
  load_balancer_name      = local.name_prefix
}

module "cert-manager" {
  source = "../../common/modules/cert-manager"

  helm_chart_release_name = format("%s-cert-manager", local.name_prefix)
  namespace               = "cert-manager"
  email                   = var.email
  selfsigned              = !local.create_r53_record
}

module "label-studio" {
  source = "../../common/modules/label-studio"

  name                     = local.name_prefix
  namespace                = "labelstudio"
  environment              = var.environment
  helm_chart_repo          = var.helm_chart_repo
  helm_chart_repo_username = var.helm_chart_repo_username
  helm_chart_repo_password = var.helm_chart_repo_password
  helm_chart_release_name  = var.helm_chart_release_name
  registry_server          = var.registry_server
  registry_username        = var.registry_username
  registry_email           = var.registry_email
  registry_password        = var.registry_password
  license_literal          = var.license_literal
  additional_set           = var.label_studio_additional_set
  enterprise               = var.enterprise

  postgresql          = var.postgresql
  postgresql_host     = var.postgresql == "rds" ? module.rds[0].host : var.postgresql_host
  postgresql_port     = var.postgresql == "rds" ? module.rds[0].port : var.postgresql_port
  postgresql_database = var.postgresql == "rds" ? module.rds[0].database : var.postgresql_database
  postgresql_username = var.postgresql == "rds" ? module.rds[0].username : var.postgresql_username
  postgresql_password = var.postgresql == "rds" ? module.rds[0].password : var.postgresql_password

  redis          = var.enterprise ? var.redis : "internal"
  redis_host     = var.redis == "elasticache" && var.enterprise ? "rediss://${module.elasticache[0].host}:${module.elasticache[0].port}/1" : var.redis_host
  redis_password = var.redis == "elasticache" && var.enterprise ? module.elasticache[0].password : var.redis_password

  host                    = local.create_r53_record ? module.route53[0].fqdn : module.nic.host
  certificate_issuer_name = module.cert-manager.issuer_name

  depends_on = [
    module.lbc,
    module.eks,
    module.cert-manager,
    module.nic,
    module.route53,
    module.rds,
    module.elasticache,
  ]
}
