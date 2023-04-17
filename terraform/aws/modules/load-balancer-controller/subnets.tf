resource "aws_ec2_tag" "shared" {
  for_each    = toset(concat(var.public_subnets, var.private_subnets))
  resource_id = each.value
  key         = format("kubernetes.io/cluster/%s-eks-cluster", var.name)
  value       = "shared"
}

resource "aws_ec2_tag" "public_subnet_eks_tags" {
  for_each    = toset(var.public_subnets)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = 1
}

resource "aws_ec2_tag" "private_subnet_eks_tags" {
  for_each    = toset(var.private_subnets)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = 1
}
