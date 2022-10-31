# Create s3 bucket resource
resource "aws_s3_bucket" "s3_bucket" {
  bucket = format("%s-ls-s3-bucket", var.name)
  tags   = var.tags

  # Force destroy bucket if there are any files exists.
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable bucket server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable CORS on bucket
resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors" {
  bucket = aws_s3_bucket.s3_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"] # TODO: Found unsupported HTTP method in CORS config. Unsupported methods are "PATCH", "OPTIONS",
    allowed_origins = ["*"] # TODO: Fix with correct URL name
    expose_headers  = ["x-amz-server-side-encryption", "x-amz-request-id", "x-amz-id-2"]
    max_age_seconds = 3600 # 1hr
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
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
