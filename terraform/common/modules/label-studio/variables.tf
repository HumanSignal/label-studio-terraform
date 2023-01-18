variable "name" {
  description = "Name is the prefix to use for resources that needs to be created"
  type        = string
}

variable "helm_chart_name" {
  description = "Label Studio Helm chart name to be installed"
  type        = string
  default     = "label-studio"
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built"
  type        = string
}

variable "helm_chart_release_name" {
  description = "Helm release name"
  type        = string
  default     = "label-studio"
}

variable "helm_chart_version" {
  description = "Label Studio Helm chart version"
  type        = string
  default     = "1.0.3"
}

variable "helm_chart_repo" {
  description = "Heartex repository name"
  type        = string
  default     = "https://charts.heartex.com/"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy Label Studio Helm chart"
  type        = string
  default     = "labelstudio"
}

variable "helm_chart_repo_username" {
  description = "Username for HTTP basic authentication against the Helm repository"
  type        = string
  default     = ""
}

variable "helm_chart_repo_password" {
  description = "Password for HTTP basic authentication against the Helm repository"
  type        = string
  default     = ""
}

# Docker config
variable "docker_registry_server" {
  description = "Docker Registry Hub"
  type        = string
  default     = "https://index.docker.io/v2/"
}

variable "docker_registry_username" {
  description = "Docker username to pull Label Studio image"
  type        = string
  default     = ""
}

variable "docker_registry_password" {
  description = "Docker password to pull Label Studio image."
  type        = string
  default     = ""
  sensitive   = true
}

variable "docker_registry_email" {
  description = "Docker email to pull Label Studio image"
  type        = string
  default     = ""
}

variable "enterprise" {
  description = "Deploy enterprise version of Label Studio"
  type        = bool
  default     = false
}

variable "license_literal" {
  description = "License link for enterprise Label Studio"
  type        = string
  sensitive   = true
}

# Persistence
variable "persistence_type" {
  type = string
  validation {
    condition     = contains(["disabled", "s3", "gcs"], var.persistence_type)
    error_message = "postgresql_type must be `disabled`, `s3`, either `gcs`"
  }
}
variable "persistence_s3_bucket_name" {
  description = "TBD"
  type        = string
  default     = ""
}
variable "persistence_s3_bucket_region" {
  description = "TBD"
  type        = string
  default     = ""
}
variable "persistence_s3_bucket_folder" {
  description = "TBD"
  type        = string
  default     = ""
}
variable "persistence_s3_role_arn" {
  description = "TBD"
  type        = string
  default     = ""
}


# Postgres
variable "postgresql_type" {
  description = "Postgresql type"
  type        = string
  default     = "internal"
  validation {
    condition     = contains(["internal", "external", "rds"], var.postgresql_type)
    error_message = "postgresql_type must be `internal`, `external`, either `rds`"
  }
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
  default     = "labelstudio"
  sensitive   = true
}
variable "postgresql_ssl_mode" {
  type    = string
  default = "require"
  validation {
    condition = contains([
      "disable",
      "allow",
      "prefer",
      "require",
      "verify-ca",
      "verify-full"
    ], var.postgresql_ssl_mode)
    error_message = "postgresql_ssl_mode must be `disable`, `allow`, `prefer`, `require`, `verify-ca`, either `verify-full`"
  }
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
variable "redis_host" {
  description = "Redis fqdn"
  type        = string
}
variable "redis_password" {
  description = "Redis password"
  type        = string
  sensitive   = true
}
variable "redis_ssl_mode" {
  type    = string
  default = "required"
  validation {
    condition = contains([
      "none",
      "optional",
      "required",
    ], var.redis_ssl_mode)
    error_message = "redis_ssl_mode must be `none`, `optional`, either `required`"
  }
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


variable "host" {
  description = "Label Studio fqdn"
  type        = string
}

variable "certificate_issuer_name" {
  description = "Cluster Issuer name to create certificate with"
  type        = string
}

variable "additional_set" {
  description = "Additional sets for Label Studio Helm chart release"
  type        = map(string)
  default     = {}
}

variable "cloud_provider" {
  type        = string
  description = "Cloud provider"
  default     = ""
}
