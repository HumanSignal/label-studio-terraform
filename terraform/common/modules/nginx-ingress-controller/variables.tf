variable "helm_chart_release_name" {
  description = "Helm release name"
  type        = string
  default     = "ingress-nginx"
}

variable "helm_chart_repo" {
  description = "Metrics Server repository name"
  type    = string
  default = "https://kubernetes.github.io/ingress-nginx"
}

variable "helm_chart_name" {
  description = "Metrics Server Helm chart name to be installed"
  type        = string
  default     = "ingress-nginx"
}

variable "helm_chart_version" {
  description = "Metrics Server Helm chart version"
  type    = string
  default = "4.6.0"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy Metrics Server Helm chart"
  type        = string
  default     = "ingress-controller"
}

variable "load_balancer_name" {
  description = "Load Balancer name to create"
  type = string
}

variable "settings" {
  description = "Additional yaml encoded values which will be passed to the Helm chart"
  default = {}
}
