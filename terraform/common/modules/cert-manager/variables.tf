variable "helm_chart_release_name" {
  description = "Helm release name"
  type        = string
  default     = "cert-manager"
}

variable "helm_chart_repo" {
  description = "Cert-manager repository name."
  type        = string
  default     = "https://charts.jetstack.io"
}

variable "helm_chart_name" {
  description = "Cert-manager Helm chart name to be installed"
  type        = string
  default     = "cert-manager"
}

variable "helm_chart_version" {
  description = "Cert-manager Helm chart version."
  type        = string
  default     = "1.11.1"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy Metrics Server Helm chart."
  type        = string
  default     = "cert-manager"
}

variable "name" {
  description = "Name is the prefix to use for resources that needs to be created."
  type        = string
}

variable "zone_name" {
  default = ""
}

variable "settings" {
  description = "Additional yaml encoded values which will be passed to the Helm chart."
  default     = {}
}

variable "email" {
  description = "Email address for certificate sing via Let's Encrypt"
  type        = string
}

variable "tls_secret_name" {
  description = ""
  type        = string
  default     = "tls"
}
