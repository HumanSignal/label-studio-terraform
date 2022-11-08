variable "vpc_id" {
}
variable "subnet_ids" {
  type = list(string)
}
variable "port" {
  type = number
  default = 6379
}
variable "password" {
  type = string
  default = "labelstudio"
}
