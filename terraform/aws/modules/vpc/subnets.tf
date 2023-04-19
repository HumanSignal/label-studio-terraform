# Create AWS public subnet.
resource "aws_subnet" "public_subnet" {
  count             = local.pub_az_count
  vpc_id            = local.vpc_id
  cidr_block        = var.public_cidr_block[count.index]
  availability_zone = local.pub_availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      "Name"                                                   = format("%s-public-subnet-%s", var.name, local.pub_availability_zones[count.index])
      format("kubernetes.io/cluster/%s-eks-cluster", var.name) = "shared"
      "kubernetes.io/role/elb"                                 = 1
    }
  )
}

# Create AWS public subnet route table association.
resource "aws_route_table_association" "public_route_table_association" {
  count          = local.pub_az_count
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}


# Create AWS private subnet.
resource "aws_subnet" "private_subnet" {
  count             = local.pri_az_count
  vpc_id            = local.vpc_id
  cidr_block        = var.private_cidr_block[count.index]
  availability_zone = local.pri_availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      "Name"                                                   = format("%s-private-subnet-%s", var.name, local.pri_availability_zones[count.index])
      format("kubernetes.io/cluster/%s-eks-cluster", var.name) = "shared"
      "kubernetes.io/role/elb"                                 = 1
    }
  )
}

# Create AWS private subnet route table association.
resource "aws_route_table_association" "private_route_table_association" {
  count          = local.pri_az_count
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}

#-------------------------------------------------------------------------------
# Routing table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = local.vpc_id
  tags   = merge(
    var.tags,
    {
      "Name" = format("%s-public_route_table", var.name)
    }
  )
}

# Create Internet route.
resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# Create Routing table for private subnets
resource "aws_route_table" "private_route_table" {
  count  = var.multi_az_nat_gateway * local.pri_az_count + var.single_nat_gateway * 1
  vpc_id = local.vpc_id
  tags   = merge(
    var.tags,
    {
      "Name" = format("%s-private_route_table", var.name)
    }
  )
}

# Create private NAT gateway route.
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


################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = local.vpc_id
  tags   = merge(
    var.tags,
    {
      "Name" = format("%s-internet-gateway", local.vpc_id)
    }
  )
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
