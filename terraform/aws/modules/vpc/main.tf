# Create Virtual Private Cloud(VPC).
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.vpc_instance_tenancy
  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = merge(var.tags, {
    "Name" = format("%s-vpc-network", var.name)
  }
  )
  lifecycle {
    ignore_changes = [tags]
  }
}

################################################################################
# VPC flow logs
################################################################################
resource "aws_flow_log" "this" {
  count           = var.enable_vpc_log ? 1 : 0
  iam_role_arn    = aws_iam_role.vpc_flow_log_cloudwatch[count.index].arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log[count.index].arn
  traffic_type    = var.traffic_type
  vpc_id          = aws_vpc.vpc.id

  tags = merge(var.tags, {
    "Name" = format("%s-vpc-network", var.name)
  }
  )
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  count           = var.enable_vpc_log ? 1 : 0
  name = format("%s-vpc-network-flow-logs", var.name)

  tags = merge(var.tags, {
    "Name" = format("%s-vpc-network", var.name)
  }
  )
}

resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  count           = var.enable_vpc_log ? 1 : 0
  name = "${var.name}-vpc-flow-log-to-cloudwatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_log_cloudwatch" {
  count           = var.enable_vpc_log ? 1 : 0
  role = aws_iam_role.vpc_flow_log_cloudwatch[count.index]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Create AWS public subnet.
resource "aws_subnet" "public_subnet" {
  count             = local.pub_az_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_cidr_block[count.index]
  availability_zone = local.pub_availability_zones[count.index]

  tags = merge(var.tags, {
    "Name" = format("%s-public-subnet-%s", var.name, local.pub_availability_zones[count.index])

    format("kubernetes.io/cluster/%s-eks-cluster", var.name) = "shared"

    "kubernetes.io/role/elb" = 1
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
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr_block[count.index]
  availability_zone = local.pri_availability_zones[count.index]

  tags = merge(var.tags, {
    "Name" = format("%s-private-subnet-%s", var.name, local.pri_availability_zones[count.index])

    format("kubernetes.io/cluster/%s-eks-cluster", var.name) = "shared"

    "kubernetes.io/role/internal-elb" = 1
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
  vpc_id = aws_vpc.vpc.id
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
  vpc_id = aws_vpc.vpc.id
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

#--------------------------------------------------------------------

# Create AWS NAT gateway for the private availability zones.
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
  vpc_id = aws_vpc.vpc.id
  tags   = merge(
    var.tags,
    {
      "Name" = format("%s-internet-gateway", aws_vpc.vpc.id)
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

#-------------------------------------------------------------------------
# Create AWS Security group
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "security_group" {
  name        = format("%s-eks-security-group", var.name)
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc.id

  egress {
    description = "Allow all outgoing connections"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-eks-security-group", var.name)
    }
  )
}

# Create AWS HTTPS Security group rule. Allow pods to communicate with the cluster API Server.
resource "aws_security_group_rule" "https_security_group_rule" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.security_group.id
  source_security_group_id = aws_security_group.worker_security_group.id
  to_port                  = 443
  type                     = "ingress"
}


# Create AWS Workstation HTTPS Security group rule.
# This security group controls networking access to the Kubernetes masters.
# We configure this with an ingress rule to allow traffic from the worker nodes.
# Allow inbound traffic from your local workstation external IP to the Kubernetes.
resource "aws_security_group_rule" "workstation_https_group_rule" {
  cidr_blocks       = [var.cluster_api_cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.security_group.id
  to_port           = 443
  type              = "ingress"
}

# Create AWS workers Security Group
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "worker_security_group" {
  name        = format("%s-eks-worker-security-group", var.name)
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.vpc.id

  egress {
    description = "Allow outgoing connections"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      "Name"                                                   = format("%s-eks-worker-security-group", var.name)
      format("kubernetes.io/cluster/%s-eks-cluster", var.name) = "shared"
    }
  )
}

# Create Worker self Security group rule
resource "aws_security_group_rule" "self_security_group_rule" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker_security_group.id
  source_security_group_id = aws_security_group.worker_security_group.id
  to_port                  = 65535
  type                     = "ingress"
}

# Create Cluster Security group rule.
resource "aws_security_group_rule" "cluster_security_group_rule" {
  description              = "Allow worker kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_security_group.id
  source_security_group_id = aws_security_group.worker_security_group.id
  to_port                  = 65535
  type                     = "ingress"
}
