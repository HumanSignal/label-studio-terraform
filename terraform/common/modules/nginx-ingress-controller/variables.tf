variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "helm_chart_name" {
  type        = string
  default     = "metrics-server"
  description = "Metrics Server Helm chart name to be installed"
}

variable "helm_release_name" {
  type        = string
  default     = "ingress-nginx"
  description = "Helm release name"
}

variable "helm_chart_version" {
  type        = string
  default     = "6.2.3"
  description = "Metrics Server Helm chart version."
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://charts.bitnami.com/bitnami"
  description = "Metrics Server repository name."
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
