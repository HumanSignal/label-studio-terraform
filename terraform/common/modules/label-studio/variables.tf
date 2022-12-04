variable "name" {
  description = "Name is the prefix to use for resources that needs to be created."
  type        = string
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built."
  type        = string
}

# Helm

variable "helm_chart_release_name" {
  type        = string
  default     = "label-studio"
  description = "Helm release name"
}

variable "helm_chart_version" {
  type        = string
  default     = "1.0.0"
  description = "Label Studio Helm chart version."
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://charts.heartex.com/"
  description = "Heartex repository name."
}

variable "namespace" {
  type        = string
  default     = "labelstudio"
  description = "Kubernetes namespace to deploy Label Studio Helm chart."
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
  description = "TBD"
  type        = string
}

variable "registry_username" {
  description = "TBD"
  type        = string
}

variable "registry_password" {
  description = "TBD"
  type        = string
}

variable "registry_email" {
  description = "TBD"
  type        = string
  default     = ""
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
variable "postgresql_database" {
  type = string
  default = "labelstudio"
}
variable "postgresql_host" {
  type = string
  default = ""
}
variable "postgresql_port" {
  type = number
  default = 5432
}
variable "postgresql_username" {
  type = string
  default = "labelstudio"
}
variable "postgresql_password" {
  type = string
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
variable "redis_host" {
  type = string
}
variable "redis_password" {
  type = string
}

# License
variable "license_secret_key" {
  description = "TBD"
  type        = string
  default     = "license"
}

variable "license_literal" {
  description = "TBD"
  type        = string
}

variable "additional_set" {
  description = "TBD"
  type        = map(string)
  default     = {}
}

variable "host" {
  type = string
}

variable "certificate_issuer_name" {
  type = string
}
