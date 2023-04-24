output "eip_addresses" {
  value = values(aws_eip.lb_eip)[*].id
  description = "List of Elastic IP addresses"
}