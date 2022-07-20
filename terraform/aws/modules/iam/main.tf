# Create AWS iam role for EKS service.
resource "aws_iam_role" "iam_role" {
  name                  = format("%s-eks-role", var.name)
  force_detach_policies = true
  tags                  = var.tags
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  lifecycle {
    create_before_destroy = true
  }
}

# create AWS cluster iam role policy attachment.
resource "aws_iam_role_policy_attachment" "clusterPolicy_iam_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_role.name
}

# Create AWS service iam role policy attachment.
resource "aws_iam_role_policy_attachment" "servicePolicy_iam_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.iam_role.name
}

# Create AWS EKSVPCResourceController iam role policy attachment. Enable Security Groups for Pods.
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "EKSVPCResourceController_iam_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.iam_role.name
}

# Create AWS worker iam role.
resource "aws_iam_role" "worker_iam_role" {
  name                  = format("%s-eks-worker-role", var.name)
  force_detach_policies = true
  tags                  = var.tags
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  lifecycle {
    create_before_destroy = true
  }
}

# Create AWS workernode iam role policy attachment.
resource "aws_iam_role_policy_attachment" "WorkerNode_iam_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_iam_role.name
}

# Create AWS iam role CNI policy attachment.
resource "aws_iam_role_policy_attachment" "CNI_policy_iam_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_iam_role.name
}

# Create AWS EC2Container registry read only iam role policy attachment.
resource "aws_iam_role_policy_attachment" "EC2ContainerRegistryReadOnly_iam_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_iam_role.name
}

# Create AWS iam instance profile group.
resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = format("%s-eks-instance-profile", var.name)
  role = aws_iam_role.worker_iam_role.name

  lifecycle {
    create_before_destroy = true
  }
}

# Create AWS LabelStudio iam role policy attachment to the worker nodes.
resource "aws_iam_role_policy_attachment" "ls_s3_iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.ls_s3_iam_policy.arn
  role       = aws_iam_role.worker_iam_role.name
}

# Create AWS iam policy document to create access to the s3 bucket to store LS files(upload, avatars, exports).
resource "aws_iam_policy" "ls_s3_iam_policy" {
  name = format("%s-eks-ls-s3-access", var.name)

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = [
          format("arn:aws:s3:::%s", var.bucket_id),
          format("arn:aws:s3:::%s/*", var.bucket_id)
        ]
      },
    ]
  })
}
