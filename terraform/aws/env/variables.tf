locals {
  # Name prefix will be used infront of every resource name.
  name_prefix = format("%s-%s", var.environment, var.name)

  # Common Tags to attach all the resources.
  tags = {
    "Environment"   = var.environment
    "resource-name" = var.name
    "project-id"    = format("%s", data.aws_caller_identity.current.id)
  }

  create_r53_record = var.zone_name != null && var.record_name != null
}

data "aws_caller_identity" "current" {}

variable "name" {
  description = "Name is the prefix to use for resources that needs to be created."
  type        = string
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built."
  type        = string
}

variable "region" {
  description = "The AWS region where terraform build resources."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of instance to be used for the Kubernetes cluster."
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired capacity for the autoscaling Group."
  type        = number
  default     = 3
}

variable "max_size" {
  description = "Maximum number of the instances in autoscaling group"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "Minimum number of the instances in autoscaling group"
  type        = number
  default     = 3
}

# Expose Subnet Settings
variable "public_cidr_block" {
  description = "List of public subnet cidr blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "private_cidr_block" {
  description = "List of private subnet cidr blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "create_r53_zone" {
  default     = false
  type        = bool
  description = "Create R53 zone for main public domain"
}

variable "create_acm_certificate" {
  default     = false
  type        = bool
  description = "Whether to create acm certificate or use existing"
}

variable "zone_name" {
  default     = null
  type        = string
  description = "Main public domain name"
}

variable "record_name" {
  default     = null
  type        = string
  description = "Main record domain name"
}

variable "eks_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  type        = string
  default     = "ON_DEMAND"
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.eks_capacity_type)
    error_message = "VM Size must be `ON_DEMAND` or `SPOT`"
  }
}

variable "ingress_namespace" {
  description = "Namespace for ingress"
  type        = string
  default     = "ingress"
}

variable "monitoring_namespace" {
  description = "Namespace for monitoring"
  type        = string
  default     = "monitoring"
}

# EKS AWS auth
variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_accounts" {
  description = "List of account maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

# Label Studio Helm Chart
variable "label_studio_helm_chart_repo" {
  description = "Heartex repository name."
  type        = string
  default     = "https://charts.heartex.com"
}
variable "label_studio_helm_chart_repo_username" {
  description = "Username for HTTP basic authentication against the Helm repository."
  type        = string
  default     = ""
}
variable "label_studio_helm_chart_repo_password" {
  description = "Password for HTTP basic authentication against the Helm repository."
  type        = string
  default     = ""
  sensitive   = true
}
variable "label_studio_helm_chart_name" {
  description = "Label Studio Helm chart name to be installed"
  type        = string
  default     = "label-studio"
}
variable "label_studio_helm_chart_version" {
  description = "Label Studio Helm chart version"
  type        = string
  default     = "1.0.16"
}

# Label Studio Docker registry
variable "label_studio_docker_registry_server" {
  description = "Docker registry fqdn to pull Label Studio image from"
  type        = string
  default     = "https://index.docker.io/v2/"
}
variable "label_studio_docker_registry_username" {
  description = "Docker username to pull Label Studio image"
  type        = string
  default     = ""
}
variable "label_studio_docker_registry_password" {
  description = "Docker password to pull Label Studio image."
  type        = string
  default     = ""
  sensitive   = true
}
variable "label_studio_docker_registry_email" {
  description = "Docker email to pull Label Studio image"
  type        = string
  default     = ""
}

variable "label_studio_additional_set" {
  description = "Additional sets for Label Studio Helm chart release"
  type        = map(string)
  default     = {}
}

variable "enterprise" {
  description = "Deploy enterprise version of Label Studio"
  type        = bool
  default     = false
}

variable "deploy_label_studio" {
  description = "Include Label Studio module?"
  type        = bool
  default     = true
}

variable "license_literal" {
  description = "License link for enterprise Label Studio"
  type        = string
  default     = null
  sensitive   = true
}

# Postgres
variable "postgresql_type" {
  description = "Postgresql type"
  type        = string
  default     = "internal"
  validation {
    condition     = contains(["internal", "external", "rds"], var.postgresql_type)
    error_message = "postgresql_type must be `internal`, `external` either `rds`"
  }
}
variable "postgresql_machine_type" {
  description = "Postgresql machine type"
  type        = string
  default     = "db.m5.large"
}
variable "postgresql_database" {
  description = "Postgresql database name"
  type        = string
  default     = "labelstudio"
}
variable "postgresql_host" {
  description = "Postgresql fqdn"
  type        = string
  default     = ""
}
variable "postgresql_port" {
  description = "Postgresql port"
  type        = number
  default     = 5432
}
variable "postgresql_username" {
  description = "Postgresql username"
  type        = string
  default     = "labelstudio"
}
variable "postgresql_password" {
  description = "Postgresql password"
  type        = string
  default     = null
  sensitive   = true
}
variable "postgresql_ssl_mode" {
  type    = string
  default = "require"
}
variable "postgresql_tls_key_file" {
  type    = string
  default = null
}
variable "postgresql_tls_crt_file" {
  type    = string
  default = null
}
variable "postgresql_ca_crt_file" {
  type    = string
  default = null
}

# Redis
variable "redis_type" {
  description = "Redis deployment type"
  type        = string
  default     = "internal"
  validation {
    condition     = contains(["internal", "external", "elasticache", "absent"], var.redis_type)
    error_message = "redis_type must be `internal`, `external`, `elasticache`, either `absent`"
  }
}
variable "redis_machine_type" {
  description = "Redis machine type"
  type        = string
  default     = "cache.t3.micro"
}
variable "redis_host" {
  description = "Redis fqdn"
  type        = string
  default     = ""
}
variable "redis_port" {
  description = "Redis port"
  type        = string
  default     = 6379
}
variable "redis_password" {
  description = "Redis password"
  type        = string
  default     = null
  sensitive   = true
}
variable "redis_ssl_mode" {
  type    = string
  default = "required"
}
variable "redis_ca_crt_file" {
  type    = string
  default = null
}
variable "redis_tls_crt_file" {
  type    = string
  default = null
}
variable "redis_tls_key_file" {
  type    = string
  default = null
}

variable "lets_encrypt_email" {
  description = "Email address for certificate sing via Let's Encrypt"
  type        = string
  default     = null
}

# Predefined VPC
variable "predefined_vpc_id" {
  type = string
  default = null
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Predefined S3 Bucket
variable "predefined_s3_bucket" {
  type = object(
    {
      name : string
      region : string
      folder : string
      kms_arn : string
    }
  )
  default = null
}

variable "create_internet_gateway" {
  default     = true
  type        = bool
  description = "Create Internet gateway"
}

variable "vpc_cidr_block" {
  description = "Virtual Private Cloud CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}
