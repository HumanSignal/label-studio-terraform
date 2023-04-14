resource "aws_iam_role" "persistence" {
  name        = "${var.name}-s3-persistence"
  description = "s3 persistence role for EKS cluster ${var.name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${var.iam_oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(var.iam_oidc_provider_url, "https://", "")}:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
POLICY
}

locals {
  kms_policy_statements = var.aws_kms_key_bucket_arn == "" ? [] : [
    {
      Effect = "Allow",
      Action = [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ],
      Resource = [
        var.aws_kms_key_bucket_arn
      ]
    },
  ]
  bucket_policy_statements = [
    {
      Effect = "Allow"
      Action = [
        "s3:ListBucket"
      ],
      Resource = [
        var.aws_s3_bucket_arn
      ]
    },
    {
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      Resource = [
        "${var.aws_s3_bucket_arn}/*"
      ]
    },
  ]
  policy = {
    Version   = "2012-10-17"
    Statement = concat(local.bucket_policy_statements, local.kms_policy_statements)
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "persistence" {
  name        = "${var.name}-s3-persistence"
  description = "Permissions for s3 bucket ${var.name}"
  policy      = jsonencode(local.policy)
}

resource "aws_iam_role_policy_attachment" "persistence" {
  role       = aws_iam_role.persistence.name
  policy_arn = aws_iam_policy.persistence.arn
}
