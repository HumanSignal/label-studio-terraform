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
