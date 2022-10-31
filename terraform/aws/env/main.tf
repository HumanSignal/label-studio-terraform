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
}

module "helm" {
  source              = "../../common/modules/helm"
  depends_on          = [module.eks]
  repository          = var.repository
  repository_username = var.repository_username
  repository_password = var.repository_password
  chart               = var.chart
  registry_server     = var.registry_server
  registry_username   = var.registry_username
  registry_email      = var.registry_email
  registry_password   = var.registry_password
  license_literal     = var.license_literal
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