variable "name" {
  description = "Name is the prefix to use for resources that needs to be created"
  type        = string
}

variable "environment" {
  description = "Name of the environment where infrastructure is being built"
  type        = string
}

variable "region" {
  description = "The AWS region in where terraform builds resources"
  type        = string
}

# Virtual Private Cloud CIDR block
variable "vpc_cidr_block" {
  description = "Virtual Private Cloud CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

# Optional Variables
## Exposed VPC Settings.
variable "vpc_instance_tenancy" {
  type    = string
  default = "default"
}

variable "vpc_enable_dns_support" {
  type    = bool
  default = "true"
}

variable "vpc_enable_dns_hostnames" {
  type    = bool
  default = "true"
}

# Expose Subnet settings.
variable "public_cidr_block" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_cidr_block" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

# Common tags for the resources.
variable "tags" {
  description = "Common tags to attach all the resources create in this project."
  type        = map(string)
  default     = {}
}

# Availability Zones variables.
# Create a NAT gateway in each availability zone to ensure a zone independent architecture.
variable "multi_az_nat_gateway" {
  description = "place a NAT gateway in each AZ"
  default     = 1
}

# By default we are using multiple NAT gateways for high availability, and zone independent architecture.
variable "single_nat_gateway" {
  description = "use a single NAT gateway to serve outbound traffic for all AZs"
  default     = 0
}

locals {
  # Query on Data to pick up availability zone automatically based on the length cidr blocks.
  pri_availability_zones = slice(data.aws_availability_zones.availability_zones.names, 0, length(var.private_cidr_block))
  pub_availability_zones = slice(data.aws_availability_zones.availability_zones.names, 0, length(var.public_cidr_block))

  # Set local variables number of availability zones based on the query results.
  pub_az_count = length(local.pub_availability_zones)
  pri_az_count = length(local.pri_availability_zones)

}

# This data block help you to get the availability zone from the region.
data "aws_availability_zones" "availability_zones" {
}

variable "enable_vpc_log" {
  description = "Enable VPC log"
  type        = bool
  default     = false
}

variable "traffic_type" {
  description = "The type of traffic to capture"
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.traffic_type)
    error_message = "Valid values: ACCEPT,REJECT, ALL."
  }
}

variable "predefined_vpc_id" {
  type        = string
  description = "Predefined VPC ID"
}
