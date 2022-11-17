variable "helm_chart_name" {
  type        = string
  default     = "metrics-server"
  description = "Metrics Server Helm chart name to be installed"
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built."
  type        = string
}

variable "helm_chart_release_name" {
  type        = string
  default     = "metrics-server"
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
  default     = "kube-system"
  description = "Kubernetes namespace to deploy Metrics Server Helm chart."
}

variable "settings" {
  default = {
    extraArgs = [
      "--kubelet-insecure-tls=true",
      "--kubelet-preferred-address-types=InternalIP"
    ]
    apiService = {
      create = true
    }
  }
  description = "Additional settings which will be passed to the Helm chart values."
}