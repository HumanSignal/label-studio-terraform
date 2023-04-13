<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.persistence](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.persistence](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.persistence](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_kms_key_bucket_arn"></a> [aws\_kms\_key\_bucket\_arn](#input\_aws\_kms\_key\_bucket\_arn) | n/a | `any` | n/a | yes |
| <a name="input_aws_s3_bucket_arn"></a> [aws\_s3\_bucket\_arn](#input\_aws\_s3\_bucket\_arn) | n/a | `any` | n/a | yes |
| <a name="input_iam_oidc_provider_arn"></a> [iam\_oidc\_provider\_arn](#input\_iam\_oidc\_provider\_arn) | AWS EKS IRSA arn | `string` | n/a | yes |
| <a name="input_iam_oidc_provider_url"></a> [iam\_oidc\_provider\_url](#input\_iam\_oidc\_provider\_url) | AWS EKS IRSA url | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name is the prefix to use for resources that needs to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_persistence_role_arn"></a> [s3\_persistence\_role\_arn](#output\_s3\_persistence\_role\_arn) | n/a |
<!-- END_TF_DOCS -->