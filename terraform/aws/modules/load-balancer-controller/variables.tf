variable "name" {
  description = "Name is the prefix to use for resources that needs to be created."
  type        = string
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built."
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
  type = string
}

variable "helm_chart_version" {
  type        = string
  default     = "1.4.6"
  description = "Metrics Server Helm chart version."
}

variable "helm_chart_release_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "Helm release name"
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "AWS Load Balancer Controller repository name."
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace to deploy AWS Load Balancer Controller Helm chart."
}