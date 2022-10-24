variable "tags" {
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
  type        = map(any)
  default     = {}
}

variable "zone_id" {
  default     = null
  description = "R53 zone id for public domain"
}

variable "create_r53_zone" {
  default     = false
  description = "Create R53 zone for main public domain"
}

variable "domain_name" {
  description = "Main public domain name"
}
