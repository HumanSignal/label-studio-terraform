variable "name" {
  description = "Name is the prefix to use for resources that needs to be created"
  type        = string
}
variable "region" {
  description = "The location of the GKE cluster"
  type        = string
}
variable "tags" {
  description = "Tags added to resources"
  type        = map(any)
  default     = {}
}
variable "machine_type" {
  type    = string
  default = "db-f1-micro"
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
variable "deletion_protection" {
  type = bool
  default = false
}
