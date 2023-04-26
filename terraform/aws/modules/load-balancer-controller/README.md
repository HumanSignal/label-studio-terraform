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
| [aws_eip.lb_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [helm_release.alb_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_availability_zones.availability_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment where infrastructure is being built | `string` | n/a | yes |
| <a name="input_helm_chart_release_name"></a> [helm\_chart\_release\_name](#input\_helm\_chart\_release\_name) | Helm release name | `string` | `"aws-load-balancer-controller"` | no |
| <a name="input_helm_chart_repo"></a> [helm\_chart\_repo](#input\_helm\_chart\_repo) | AWS Load Balancer Controller repository name | `string` | `"https://aws.github.io/eks-charts"` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | AWS Load Balancer Helm chart version | `string` | `"1.5.1"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name is the prefix to use for resources that needs to be created | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to deploy AWS Load Balancer Controller Helm chart | `string` | `"ingress"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | AWS EKS IRSA provider | `string` | n/a | yes |
| <a name="input_private_cidr_block"></a> [private\_cidr\_block](#input\_private\_cidr\_block) | List of private subnet CIDR blocks | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional yaml encoded values which will be passed to the Helm chart. | `map` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags to attach all the resources create in this project. | `map(string)` | `{}` | no |
| <a name="input_use_eip_for_nat_gateways"></a> [use\_eip\_for\_nat\_gateways](#input\_use\_eip\_for\_nat\_gateways) | Use EIP for nat gateway | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eip_addresses"></a> [eip\_addresses](#output\_eip\_addresses) | List of Elastic IP addresses |
<!-- END_TF_DOCS -->