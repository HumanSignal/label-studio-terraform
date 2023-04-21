variable "tags" {
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
  type        = map(any)
  default     = {}
}

variable "create_r53_zone" {
  default     = false
  description = "Create R53 zone for main public domain"
}

variable "zone_name" {
  description = "Main public domain name"
}

variable "record_name" {
  description = "Subdomain name"
  default = "www"
}

variable "alias_zone_id" {
  description = "Zone id for alias"
  type = string
}

variable "load_balancer_dns_name" {
  description = "fqdn for record alias"
  type = string
}

variable "load_balancer_zone_id" {
  description = "Zone id of fqdn"
  type = string
}
