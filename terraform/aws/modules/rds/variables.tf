variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "postgresql_database" {
  type    = string
  default = "labelstudio"
}
variable "postgresql_username" {
  type    = string
  default = "labelstudio"
}
variable "postgresql_password" {
  type    = string
  default = "labelstudio"
}
