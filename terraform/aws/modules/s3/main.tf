# Create s3 bucket resource
#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "s3_bucket" {
  bucket = format("%s-ls-s3-bucket", var.name)
  tags   = var.tags

  # Force destroy bucket if there are any files exists.
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
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

  bucket = aws_s3_bucket.s3_bucket.id

  target_bucket = aws_s3_bucket.s3_log_bucket[count.index]
  target_prefix = "log/"
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
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
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.bucket.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Enable CORS on bucket
resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors" {
  bucket = aws_s3_bucket.s3_bucket.id

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
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
