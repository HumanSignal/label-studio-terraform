variable "helm_chart_release_name" {
  type        = string
  default     = "cert-manager"
  description = "Helm release name"
}

variable "helm_chart_repo" {
  type    = string
  default = "https://charts.jetstack.io"

  description = "Cert-manager repository name."
}

variable "helm_chart_name" {
  type        = string
  default     = "cert-manager"
  description = "Cert-manager Helm chart name to be installed"
}

variable "helm_chart_version" {
  type    = string
  default = "1.10.1"

  description = "Cert-manager Helm chart version."
}

variable "namespace" {
  type        = string
  default     = "cert-manager"
  description = "Kubernetes namespace to deploy Metrics Server Helm chart."
}

variable "settings" {
  default = {

  }
  description = "Additional yaml encoded values which will be passed to the Helm chart."
}

variable "email" {
  type = string
}

