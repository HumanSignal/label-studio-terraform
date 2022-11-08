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
  type    = string
  default = "labelstudio"
}
