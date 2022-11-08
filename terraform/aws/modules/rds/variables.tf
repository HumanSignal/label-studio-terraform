variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
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
  type    = string
  default = "labelstudio"
}
