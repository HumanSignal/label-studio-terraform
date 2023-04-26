<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | Cert-manager Helm chart name to be installed | `string` | `"external-dns"` | no |
| <a name="input_helm_chart_release_name"></a> [helm\_chart\_release\_name](#input\_helm\_chart\_release\_name) | Helm release name | `string` | `"external-dns"` | no |
| <a name="input_helm_chart_repo"></a> [helm\_chart\_repo](#input\_helm\_chart\_repo) | Cert-manager repository name. | `string` | `"https://kubernetes-sigs.github.io/external-dns"` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Cert-manager Helm chart version. | `string` | `"1.9.0"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name is the prefix to use for resources that needs to be created. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to deploy Metrics Server Helm chart. | `string` | `"external-dns"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional yaml encoded values which will be passed to the Helm chart. | `map` | `{}` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | n/a | `any` | n/a | yes |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->