output "eip_addresses" {
  value = aws_eip.lb_eip.*.id
  description = "List of Elastic IP addresses"
}