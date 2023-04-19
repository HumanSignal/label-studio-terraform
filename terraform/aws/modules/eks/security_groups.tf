################################################################################
# Create AWS Security groups for EKS
################################################################################
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "security_group" {
  name        = format("%s-eks-security-group", var.name)
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

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
  vpc_id      = var.vpc_id

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
