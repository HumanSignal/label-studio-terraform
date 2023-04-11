# Create s3 bucket resource
#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "s3_bucket" {
  count = var.predefined_s3_bucket == null ? 1 : 0

  bucket = format("%s-ls-s3-bucket", var.name)
  tags   = var.tags

  # Force destroy bucket if there are any files exists.
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_s3_bucket" "predefined_s3_bucket" {
  count = var.predefined_s3_bucket == null ? 0 : 1

  bucket = var.predefined_s3_bucket.name
}

locals {
  aws_s3_bucket_id     = var.predefined_s3_bucket == null ? aws_s3_bucket.s3_bucket[0].id : data.aws_s3_bucket.predefined_s3_bucket[0].id
  aws_s3_bucket_arn    = var.predefined_s3_bucket == null ? aws_s3_bucket.s3_bucket[0].arn : data.aws_s3_bucket.predefined_s3_bucket[0].arn
  aws_s3_bucket_bucket = var.predefined_s3_bucket == null ? aws_s3_bucket.s3_bucket[0].bucket : data.aws_s3_bucket.predefined_s3_bucket[0].bucket
  aws_s3_bucket_region = var.predefined_s3_bucket == null ? aws_s3_bucket.s3_bucket[0].region : data.aws_s3_bucket.predefined_s3_bucket[0].region
  aws_s3_bucket_folder = var.predefined_s3_bucket == null ? var.folder : var.predefined_s3_bucket.folder
}

resource "aws_s3_bucket" "s3_log_bucket" {
  count = var.enable_log_bucket ? 1 : 0

  bucket = format("%s-ls-s3-log-bucket", var.name)
  tags   = var.tags

  # Force destroy bucket if there are any files exists.
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket_acl" "s3_log_bucket_acl" {
  count = var.enable_log_bucket ? 1 : 0

  bucket = aws_s3_bucket.s3_log_bucket[count.index]
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "s3_bucket_logging" {
  count = var.enable_log_bucket ? 1 : 0

  bucket = local.aws_s3_bucket_id

  target_bucket = aws_s3_bucket.s3_log_bucket[count.index]
  target_prefix = "log/"
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = local.aws_s3_bucket_id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "bucket" {
  description              = format("KMS key for %s-ls-s3-log-bucket bucket", var.name)
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  deletion_window_in_days  = 10
}

# Enable bucket server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
  bucket = local.aws_s3_bucket_bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.bucket.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Enable CORS on bucket
resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors" {
  bucket = local.aws_s3_bucket_id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    # TODO: Found unsupported HTTP method in CORS config. Unsupported methods are "PATCH", "OPTIONS",
    allowed_origins = ["*"] # TODO: Fix with correct URL name
    expose_headers  = ["x-amz-server-side-encryption", "x-amz-request-id", "x-amz-id-2"]
    max_age_seconds = 3600 # 1hr
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = local.aws_s3_bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

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

resource "aws_iam_policy" "persistence" {
  name        = "${var.name}-s3-persistence"
  description = "Permissions for s3 bucket ${var.name}"
  policy      = jsonencode({
    "Version"   = "2012-10-17"
    "Statement" = [
      {
        "Effect" = "Allow"
        "Action" = [
          "s3:ListBucket"
        ],
        "Resource" = [
          local.aws_s3_bucket_arn
        ]
      },
      {
        "Effect" : "Allow"
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "${local.aws_s3_bucket_arn}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        "Resource" : [
          aws_kms_key.bucket.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "persistence" {
  role       = aws_iam_role.persistence.name
  policy_arn = aws_iam_policy.persistence.arn
}
