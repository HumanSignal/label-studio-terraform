# Output attribute id of the VPC
output "aws_vpc_id" {
  value = aws_vpc.vpc.id
}
# Output attribute of the VPC cidr block.
output "aws_vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

# Output attributes of the public and private subnets
output "aws_subnet_public_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "aws_subnet_private_ids" {
  value = aws_subnet.private_subnet.*.id
}

# Output attributes of the route table ids.
output "aws_route_table_public_ids" {
  value = aws_route_table.public_route_table.id
}

output "aws_route_table_private_ids" {
  value = aws_route_table.private_route_table.*.id
}

# Output attributes of the NAT gateway
output "aws_nat_gateway_count" {
  value = length(aws_nat_gateway.nat_gateway.*.id)
}

output "aws_nat_gateway_ids" {
  value = aws_nat_gateway.nat_gateway.*.id
}

# Output attribute of the Elastic IP.
output "aws_eip_nat_ips" {
  value = aws_eip.mod_nat_eip.*.public_ip
}

# Output attributes of the Security Groups.
output "security_group_id" {
  value = aws_security_group.security_group.id
}

output "worker_security_group_id" {
  value = aws_security_group.worker_security_group.id
}
