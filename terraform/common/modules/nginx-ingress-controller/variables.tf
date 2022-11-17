variable "helm_chart_release_name" {
  type        = string
  default     = "ingress-nginx"
  description = "Helm release name"
}

variable "helm_chart_repo" {
  type    = string
  default = "https://kubernetes.github.io/ingress-nginx"

  description = "Metrics Server repository name."
}

variable "helm_chart_name" {
  type        = string
  default     = "ingress-nginx"
  description = "Metrics Server Helm chart name to be installed"
}

variable "helm_chart_version" {
  type    = string
  default = "4.1.4"

  description = "Metrics Server Helm chart version."
}

variable "namespace" {
  type        = string
  default     = "ingress-controller"
  description = "Kubernetes namespace to deploy Metrics Server Helm chart."
}

variable "settings" {
  default = {

  }
  description = "Additional yaml encoded values which will be passed to the Helm chart."
}
