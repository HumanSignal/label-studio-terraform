variable "name" {
  description = "Name is the prefix to use for resources that needs to be created."
  type        = string
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built."
  type        = string
}

variable "role_arn" {
  description = "IAM role arn to attach the EKS cluster."
  type        = string
}

variable "worker_role_arn" {
  description = "IAM worker role arn to attach the EKS cluster."
  type        = string
}

variable "region" {
  description = "The AWS region where terraform builds resources."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet id to attach the EKS cluster."
}

variable "security_group_id" {
  description = "Security group id to configure EKS cluster."
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets to create the resources."
}

variable "tags" {
  description = "Common tags to attach all the resources create in this project."
  type        = map(string)
}

variable "instance_profile_name" {
  description = "Instance profile name to attach aws launch configuration."
  type        = string
}

variable "cluster_version" {
  description = "Version of the EKS cluster."
  type        = string
  default     = "1.24"
}

variable "instance_type" {
  description = "Type of instance to be used for the Kubernetes cluster."
  type        = string
}

variable "desired_capacity" {
  description = "Desired capacity for the autoscaling Group."
  type        = number
}

variable "max_size" {
  description = "Maximum number of the instances in autoscaling group"
  type        = number
}

variable "min_size" {
  description = "Minimum number of the instances in autoscaling group"
  type        = number
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  type        = string
  default     = "ON_DEMAND"
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "VM Size must be `ON_DEMAND` or `SPOT`"
  }
}

variable "metrics_server_enabled" {
  description = "Enable Metrics server"
  type        = bool
  default     = true
}