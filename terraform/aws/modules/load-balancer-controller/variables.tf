variable "name" {
  description = "Name is the prefix to use for resources that needs to be created"
  type        = string
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built"
  type        = string
}

variable "iam_oidc_provider" {
  description = "AWS EKS IRSA provider"
  type        = object({
    url = string
    arn = string
  })
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "helm_chart_version" {
  type        = string
  default     = "1.5.1"
  description = "AWS Load Balancer Helm chart version"
}

variable "helm_chart_release_name" {
  description = "Helm release name"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "helm_chart_repo" {
  description = "AWS Load Balancer Controller repository name"
  type        = string
  default     = "https://aws.github.io/eks-charts"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy AWS Load Balancer Controller Helm chart"
  type        = string
  default     = "ingress"
}
