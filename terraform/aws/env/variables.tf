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

locals {
  # Name prefix will be used infront of every resource name.
  name_prefix = format("%s-%s", var.environment, var.name)

  # Common Tags to attach all the resources.
  tags = {
    "Environment"   = var.environment
    "resource-name" = var.name
    "project-id"    = format("%s", data.aws_caller_identity.current.id)
  }
}

data "aws_caller_identity" "current" {}

variable "create_r53_zone" {
  default     = false
  description = "Create R53 zone for main public domain"
}

variable "create_acm_certificate" {
  default     = false
  description = "Whether to create acm certificate or use existing"
}

variable "domain_name" {
  description = "Main public domain name"
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

# Helm
variable "helm_chart_repo" {
  description = "Heartex repository name."
  type        = string
  default     = "https://charts.heartex.com"
}

variable "helm_chart_repo_username" {
  description = "Username for HTTP basic authentication against the Helm repository."
  type        = string
}

variable "helm_chart_repo_password" {
  description = "Password for HTTP basic authentication against the Helm repository."
  type        = string
}

variable "helm_chart_release_name" {
  type        = string
  default     = "label-studio"
  description = "Helm release name"
}

# Docker config
variable "registry_server" {
  description = "TBD"
  type        = string
  default     = "https://index.docker.io/v2/"
}

variable "registry_username" {
  description = "TBD"
  type        = string
}

variable "registry_email" {
  description = "TBD"
  type        = string
  default     = ""
}

variable "registry_password" {
  description = "TBD"
  type        = string
}

# License
variable "license_literal" {
  description = "TBD"
  type        = string
}

variable "label_studio_additional_set" {
  description = "TBD"
  type        = map(string)
  default     = {}
}

variable "enterprise" {
  description = "TBD"
  type        = bool
  default     = false
}

# Postgres
variable "postgresql" {
  description = "TBD"
  type        = string
  default     = "internal"
  validation {
    condition     = contains(["internal", "rds"], var.postgresql)
    error_message = "postgresql must be either `internal` either `rds`"
  }
}
variable "postgresql_machine_type" {
  type    = string
  default = "db.m5.large"
}
variable "postgresql_database" {
  type    = string
  default = "labelstudio"
}
variable "postgresql_host" {
  type    = string
  default = ""
}
variable "postgresql_port" {
  type    = number
  default = 5432
}
variable "postgresql_username" {
  type    = string
  default = "labelstudio"
}
variable "postgresql_password" {
  type    = string
  default = "labelstudio"
}

# Redis
variable "redis" {
  description = "TBD"
  type        = string
  default     = "internal"
  validation {
    condition     = contains(["internal", "elasticache"], var.redis)
    error_message = "postgresql must be either `internal` either `elasticache`"
  }
}
variable "redis_machine_type" {
  type    = string
  default = "cache.t3.micro"
}
variable "redis_host" {
  type    = string
  default = ""
}
variable "redis_port" {
  type    = string
  default = 6379
}
variable "redis_password" {
  type    = string
  default = "labelstudio"
}
