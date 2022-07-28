variable "name" {
  description = "Name is the prefix to use for resources that needs to be created."
  type        = string
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built."
  type        = string
}

variable "region" {
  description = "The AWS region where terraform builds resources."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Common tags to attach all the resources create in this project."
  type        = map(string)
}

variable "bucket_id" {
  description = "Bucket name (aka ID) to attach LabelStudio s3 access policy."
  type        = string
}
