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
| [aws_kms_key.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3_log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.s3_log_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.s3_bucket_cors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_logging.s3_bucket_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_public_access_block.s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_bucket_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.s3_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket.predefined_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_log_bucket"></a> [enable\_log\_bucket](#input\_enable\_log\_bucket) | Enable log bucket | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment where infrastructure is being built. | `string` | n/a | yes |
| <a name="input_folder"></a> [folder](#input\_folder) | n/a | `string` | `""` | no |
| <a name="input_iam_oidc_provider_arn"></a> [iam\_oidc\_provider\_arn](#input\_iam\_oidc\_provider\_arn) | AWS EKS IRSA arn | `string` | n/a | yes |
| <a name="input_iam_oidc_provider_url"></a> [iam\_oidc\_provider\_url](#input\_iam\_oidc\_provider\_url) | AWS EKS IRSA url | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name is the prefix to use for resources that needs to be created. | `string` | n/a | yes |
| <a name="input_predefined_s3_bucket"></a> [predefined\_s3\_bucket](#input\_predefined\_s3\_bucket) | n/a | <pre>object(<br>    {<br>      name : string<br>      region : string<br>      folder : string<br>    }<br>  )</pre> | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where terraform builds resources. | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags to attach all the resources create in this project. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The arn of the bucket will be in format arn:aws:s3::bucketname |
| <a name="output_bucket_folder"></a> [bucket\_folder](#output\_bucket\_folder) | n/a |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Bucket Name (aka ID) |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | n/a |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | n/a |
| <a name="output_kms_arn"></a> [kms\_arn](#output\_kms\_arn) | n/a |
| <a name="output_s3_persistence_role_arn"></a> [s3\_persistence\_role\_arn](#output\_s3\_persistence\_role\_arn) | n/a |
<!-- END_TF_DOCS -->