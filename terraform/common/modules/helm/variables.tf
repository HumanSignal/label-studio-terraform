# Helm
variable "repository" {
  description = "TBD"
  type        = string
}

variable "repository_username" {
  description = "Username for HTTP basic authentication against the Helm repository."
  type        = string
}

variable "repository_password" {
  description = "Password for HTTP basic authentication against the Helm repository."
  type        = string
}

variable "chart" {
  description = "TBD"
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
