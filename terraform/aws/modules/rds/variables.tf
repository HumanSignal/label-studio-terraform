variable "name" {
  description = "Name is the prefix to use for resources that needs to be created"
  type        = string
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built"
  type        = string
}

variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "port" {
  type    = number
  default = 5432
}
variable "database" {
  type    = string
  default = "labelstudio"
}
variable "username" {
  type    = string
  default = "labelstudio"
}
variable "password" {
  type      = string
  default   = "labelstudio"
  sensitive = true
}
variable "machine_type" {
  type    = string
  default = "db.m5.large"
}

variable "tags" {
  description = "Tags added to resources"
  type        = map(any)
  default     = {}
}