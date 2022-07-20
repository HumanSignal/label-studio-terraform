# AWS IAM EKS role arn.
output "role_arn" {
  description = "IAM role for EKS service."
  value       = aws_iam_role.iam_role.arn
}

# AWS IAM worker role arn.
output "worker_role_arn" {
  description = "IAM role arn for EKS worker nodes."
  value       = aws_iam_role.worker_iam_role.arn
}

# AWS IAM instance profile id.
output "iam_instance_profile" {
  description = "IAM instance profile for the EKS worker nodes."
  value       = aws_iam_instance_profile.iam_instance_profile.id
}
