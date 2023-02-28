variable "name" {
  description = "Name is the prefix to use for resources that needs to be created."
  type        = string
}

variable "environment" {
  description = "Name of the environment where infrastructure being built."
  type        = string
}

variable "project_id" {
  description = "The project ID where all resources will be launched."
  type        = string
}

variable "initial_node_count" {
  description = "Node count to define number of nodes per Zone, each region by default creates three nodes."
  type        = number
}

variable "max_node_count" {
  type = number
}

variable "min_node_count" {
  type = number
}

variable "machine_type" {
  description = "Type of machines which are used by cluster node pool"
  type        = string
}

variable "preemptible_nodes" {
  description = "Whether the underlying node VMs are preemptible"
  type = bool
  default = false
}

variable "spot_nodes" {
  description = "Whether the underlying node VMs are spot"
  type = bool
  default = false
}

variable "node_disk_size_gb" {
  description = "Size of the disk attached to each node, specified in GB"
  type = number
  default = 30
}

variable "region" {
  description = "The location of the GKE cluster"
  type        = string
}

variable "network_link" {
  description = "network link variable from vpc module outputs"
  default     = ""
}

variable "subnetwork_link" {
  description = "subnetworking link variable from vpc module outputs"
  default     = ""
}

variable "service_account" {
  description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters"
  default     = ""
}

variable "enable_private_endpoint" {
  description = "(Beta) Whether the master's internal IP address is used as the cluster endpoint"
  default     = false
  type        = bool
}

variable "enable_private_nodes" {
  description = "(Beta) Whether nodes have internal IP addresses only"
  default     = false
  type        = bool
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation (size must be /28) to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  default     = "10.0.0.0/28"
}
