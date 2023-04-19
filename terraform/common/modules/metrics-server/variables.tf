variable "helm_chart_name" {
  description = "Metrics Server Helm chart name to be installed"
  type        = string
  default     = "metrics-server"
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built"
  type        = string
}

variable "helm_chart_release_name" {
  description = "Helm release name"
  type        = string
  default     = "metrics-server"
}

variable "helm_chart_version" {
  description = "Metrics Server Helm chart version"
  type        = string
  default     = "6.2.17"
}

variable "helm_chart_repo" {
  description = "Metrics Server repository name"
  type        = string
  default     = "https://charts.bitnami.com/bitnami"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy Metrics Server Helm chart"
  type        = string
  default     = "monitoring"
}

variable "settings" {
  description = "Additional settings which will be passed to the Helm chart values"
  default = {
    extraArgs = [
      "--kubelet-insecure-tls=true",
      "--kubelet-preferred-address-types=InternalIP"
    ]
    apiService = {
      create = true
    }
  }
}