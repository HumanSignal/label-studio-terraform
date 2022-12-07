variable "name" {
  description = "Name is the prefix to use for resources that needs to be created"
  type        = string
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built"
  type        = string
}

variable "helm_chart_release_name" {
  description = "Helm chart release name"
  type        = string
  default     = "label-studio"
}

variable "helm_chart_version" {
  description = "Label Studio Helm chart version"
  type        = string
  default     = "1.0.0"
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
  description = "Username for HTTP basic authentication against the Helm repository."
  type        = string
}

variable "helm_chart_repo_password" {
  description = "Password for HTTP basic authentication against the Helm repository."
  type        = string
}

# Docker config
variable "registry_server" {
  description = "Docker registry fqdn to pull label studio image from."
  type        = string
}

variable "registry_username" {
  description = "Docker username to pull label studio image."
  type        = string
}

variable "registry_password" {
  description = "Docker password to pull label studio image."
  type        = string
  sensitive   = true
}

variable "registry_email" {
  description = "Docker email to pull label studio image"
  type        = string
  default     = ""
}

variable "enterprise" {
  description = "deploy enterprise version of Label Studio"
  type        = bool
  default     = false
}

variable "license_literal" {
  description = "License link"
  type        = string
  sensitive   = true
}

# Postgres
variable "postgresql" {
  description = "Postgresql type"
  type        = string
  default     = "internal"
  validation {
    condition     = contains(["internal", "rds"], var.postgresql)
    error_message = "postgresql must be either `internal` either `rds`"
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

# Redis
variable "redis" {
  description = "Redis type"
  type        = string
  default     = "internal"
  validation {
    condition     = contains(["internal", "elasticache", "absent"], var.redis)
    error_message = "redis must be `internal`, `elasticache`, either `absent`"
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

variable "host" {
  description = "Label Studio fqdn"
  type        = string
}

variable "certificate_issuer_name" {
  description = "Cluster Issuer name to create certificate with"
  type        = string
}
