variable "name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "port" {
  type    = number
  default = 6379
}
variable "password" {
  type    = string
  default = "labelstudio"
}
variable "machine_type" {
  type    = string
  default = "cache.t3.micro"
}
variable "tags" {
  description = "Tags added to resources."
  type        = map(any)
  default     = {}
}