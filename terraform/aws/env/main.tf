# Create VPC
module "vpc" {
  source             = "../modules/vpc"
  name               = local.name_prefix
  environment        = var.environment
  region             = var.region
  public_cidr_block  = var.public_cidr_block
  private_cidr_block = var.private_cidr_block
  tags               = local.tags
}

# Create Identity Access Management
module "iam" {
  source      = "../modules/iam"
  name        = local.name_prefix
  region      = var.region
  environment = var.environment
  tags        = local.tags
  bucket_id   = module.s3.bucket_id
}

# Create S3 bucket
module "s3" {
  source      = "../modules/s3"
  name        = local.name_prefix
  environment = var.environment
  tags        = local.tags
}

# Create Elastic Kubernetes Service
module "eks" {
  source                = "../modules/eks"
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

module "rds" {
  source = "../modules/rds"
  count  = var.postgresql == "rds" ? 1 : 0

  name         = local.name_prefix
  environment  = var.environment
  vpc_id       = module.vpc.aws_vpc_id
  subnet_ids   = module.vpc.aws_subnet_private_ids
  machine_type = var.postgresql_machine_type
  database     = var.postgresql_database
  username     = var.postgresql_username
  password     = var.postgresql_password

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

  depends_on = [module.vpc]
}

module "lbc" {
  source      = "../modules/load-balancer-controller"
  name        = local.name_prefix
  environment = var.environment

  cluster_name = module.eks.cluster_name

  iam_oidc_provider = module.eks.iam_oidc_provider

  depends_on = [
    module.eks,
    module.vpc,
  ]
}

module "helm" {
  source      = "../../common/modules/helm"
  name        = local.name_prefix
  environment = var.environment

  repository          = var.repository
  repository_username = var.repository_username
  repository_password = var.repository_password
  chart               = var.chart
  registry_server     = var.registry_server
  registry_username   = var.registry_username
  registry_email      = var.registry_email
  registry_password   = var.registry_password
  license_literal     = var.license_literal
  additional_set      = var.label_studio_additional_set
  enterprise          = var.enterprise

  postgresql          = var.postgresql
  postgresql_host     = var.postgresql == "rds" ? module.rds[0].host : var.postgresql_host
  postgresql_port     = var.postgresql == "rds" ? module.rds[0].port : var.postgresql_port
  postgresql_database = var.postgresql == "rds" ? module.rds[0].database : var.postgresql_database
  postgresql_username = var.postgresql == "rds" ? module.rds[0].username : var.postgresql_username
  postgresql_password = var.postgresql == "rds" ? module.rds[0].password : var.postgresql_password

  redis          = var.enterprise ? var.redis : "internal"
  redis_host     = var.redis == "elasticache" && var.enterprise ? module.elasticache[0].host : var.redis_host
  redis_password = var.redis == "elasticache" && var.enterprise ? module.elasticache[0].password : var.redis_password

  depends_on = [
    module.lbc,
    module.eks,
    module.rds,
    module.elasticache,
  ]
}

#module "route53" {
#  source      = "../modules/route53"
#  count       = var.create_r53_zone ? 1 : 0
#  domain_name = var.domain_name
#  tags        = local.tags
#}
#
#module "acm" {
#  source      = "../modules/acm"
#  count       = var.create_acm_certificate ? 1 : 0
#  domain_name = var.domain_name
#  tags        = local.tags
#}