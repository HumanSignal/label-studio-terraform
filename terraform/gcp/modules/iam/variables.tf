variable "name" {
  description = "Name is the prefix to use for resources that needs to be created."
  type        = string
}

variable "project_id" {
  description = "The project in which to hold the components"
  type        = string
}

variable "region" {
  description = "The region in which to create the VPC network"
  type        = string
}

variable "service_account_iam_roles" {
  description = "list of roles for the node pool service account"
  type        = list(string)
  default     = [
    "roles/artifactregistry.reader",
    "roles/storage.objectViewer",
    "roles/servicemanagement.serviceController",
    "roles/logging.logWriter",
    "roles/monitoring.admin",
    "roles/cloudtrace.agent"
  ]
}

variable "project_services" {
  type    = list(string)
  default = []
}
