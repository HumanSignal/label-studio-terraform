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
      "kubernetes.io/role/internal-elb"                        = 1
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
