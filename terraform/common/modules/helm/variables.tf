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
