# AWS s3 bucket id
output "bucket_id" {
  value       = local.aws_s3_bucket_id
  description = "Bucket Name (aka ID)"
}

# AWS s3 bucket arn
output "bucket_arn" {
  value       = local.aws_s3_bucket_arn
  description = "The arn of the bucket will be in format arn:aws:s3::bucketname"
}

output "bucket_name" {
  value = local.aws_s3_bucket_bucket
}

output "bucket_region" {
  value = local.aws_s3_bucket_region
}

output "bucket_folder" {
  value = local.aws_s3_bucket_folder
}

output "kms_arn" {
  value = aws_kms_key.bucket.arn
}

output "s3_persistence_role_arn" {
  value = aws_iam_role.persistence.arn
}
