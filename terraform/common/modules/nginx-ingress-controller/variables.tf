variable "helm_chart_release_name" {
  description = "Helm release name"
  type        = string
  default     = "ingress-nginx"
}

variable "helm_chart_repo" {
  description = "Nginx Ingress Controller repository name"
  type    = string
  default = "https://kubernetes.github.io/ingress-nginx"
}

variable "helm_chart_name" {
  description = "Nginx Ingress Controller Helm chart name to be installed"
  type        = string
  default     = "ingress-nginx"
}

variable "helm_chart_version" {
  description = "Nginx Ingress Controller Helm chart version"
  type    = string
  default = "4.6.0"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy Nginx Ingress Controller Helm chart"
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

variable "vpc_cidr_block" {
  description = "Virtual Private Cloud CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}