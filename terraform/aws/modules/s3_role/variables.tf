# Variables to create s3 bucket
variable "name" {
  description = "Name is the prefix to use for resources that needs to be created."
  type        = string
}

variable "aws_s3_bucket_arn" {}

variable "aws_kms_key_bucket_arn" {}

variable "iam_oidc_provider_arn" {
  description = "AWS EKS IRSA arn"
  type        = string
}

variable "iam_oidc_provider_url" {
  description = "AWS EKS IRSA url"
  type        = string
}
