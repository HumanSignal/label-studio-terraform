variable "tags" {
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
  type        = map(any)
  default     = {}
}

variable "create_r53_zone" {
  default     = false
  description = "Create R53 zone for main public domain"
}

variable "domain_name" {
  description = "Main public domain name"
}

variable "record_name" {
  default = "www"
}

variable "alias_name" {
  type = string
}

variable "alias_zone_id" {
  type = string
}
