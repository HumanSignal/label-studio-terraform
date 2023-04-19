################################################################################
# Create private NAT gateway route.
################################################################################
resource "aws_route" "private_nat_gateway_route" {
  count                  = var.multi_az_nat_gateway * local.pri_az_count + var.single_nat_gateway * 1
  route_table_id         = element(aws_route_table.private_route_table.*.id, count.index)
  nat_gateway_id         = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [
    aws_route_table.private_route_table,
    aws_nat_gateway.nat_gateway,
  ]
}

################################################################################
# Create AWS NAT gateway for the private availability zones.
################################################################################

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.multi_az_nat_gateway * local.pri_az_count + var.single_nat_gateway * 1
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  allocation_id = element(aws_eip.mod_nat_eip.*.id, count.index)
  tags          = merge(var.tags, {
    "Name" = format("%s-nat-gateway-%s", var.name, local.pri_availability_zones[count.index])
  })
  depends_on = [
    aws_internet_gateway.internet_gateway,
    aws_eip.mod_nat_eip,
    aws_subnet.public_subnet,
  ]
  lifecycle {
    ignore_changes = [tags]
  }
}

#----------------------------------------------------------------------
# Create Elastic IP address for the NAT gateway.
resource "aws_eip" "mod_nat_eip" {
  count = var.multi_az_nat_gateway * local.pri_az_count + var.single_nat_gateway * 1
  tags  = merge(var.tags, {
    "Name" = format("%s-elasticIP-%s", var.name, local.pub_availability_zones[count.index])
  })
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "internet_gateway" {
  count = var.create_internet_gateway ? 1 : 0
  vpc_id = local.vpc_id
  tags   = merge(
    var.tags,
    {
      "Name" = format("%s-internet-gateway", local.vpc_id)
    }
  )
}

# Create Internet route.
resource "aws_route" "internet_gateway_route" {
  count = var.create_internet_gateway ? 1 : 0
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway[0].id
}