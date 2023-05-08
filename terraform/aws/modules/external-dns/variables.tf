variable "helm_chart_release_name" {
  description = "Helm release name"
  type        = string
  default     = "external-dns"
}

variable "helm_chart_repo" {
  description = "Cert-manager repository name."
  type        = string
  default     = "https://kubernetes-sigs.github.io/external-dns"
}

variable "helm_chart_name" {
  description = "Cert-manager Helm chart name to be installed"
  type        = string
  default     = "external-dns"
}

variable "helm_chart_version" {
  description = "Cert-manager Helm chart version."
  type        = string
  default     = "1.12.2"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy Metrics Server Helm chart."
  type        = string
  default     = "external-dns"
}

variable "name" {
  description = "Name is the prefix to use for resources that needs to be created."
  type        = string
}

variable "region" {}

variable "zone_name" {}

variable "zone_id" {}

variable "oidc_provider_arn" {}

variable "helm_values" {
  description = "Additional yaml encoded values which will be passed to the Helm chart."
  type        = map(any)
  default     = {}
}
