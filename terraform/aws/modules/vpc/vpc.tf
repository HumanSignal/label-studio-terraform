# Create Virtual Private Cloud(VPC).
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc" {
  count = var.predefined_vpc_id == null ? 1 : 0

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

data "aws_vpc" "vpc" {
  count = var.predefined_vpc_id == null ? 0 : 1

  id = var.predefined_vpc_id
}

locals {
  vpc_id = var.predefined_vpc_id == null ? aws_vpc.vpc[0].id : data.aws_vpc.vpc[0].id
}

################################################################################
# VPC flow logs
################################################################################
resource "aws_flow_log" "flow_log" {
  count           = var.enable_vpc_log ? 1 : 0
  iam_role_arn    = aws_iam_role.vpc_flow_log_cloudwatch[count.index].arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log[count.index].arn
  traffic_type    = var.traffic_type
  vpc_id          = local.vpc_id

  tags = merge(var.tags, {
    "Name" = format("%s-vpc-network", var.name)
  }
  )
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  count = var.enable_vpc_log ? 1 : 0
  name  = format("%s-vpc-network-flow-logs", var.name)

  tags = merge(var.tags, {
    "Name" = format("%s-vpc-network", var.name)
  }
  )
}

resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  count = var.enable_vpc_log ? 1 : 0
  name  = "${var.name}-vpc-flow-log-to-cloudwatch"

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
  count = var.enable_vpc_log ? 1 : 0
  role  = aws_iam_role.vpc_flow_log_cloudwatch[count.index]

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
