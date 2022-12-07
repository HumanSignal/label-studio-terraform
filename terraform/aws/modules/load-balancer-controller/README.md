<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.alb_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.service_account](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_cluster_role.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_secret_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.eks_oidc_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [kubernetes_service_account.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment where infrastructure is being built. | `string` | n/a | yes |
| <a name="input_helm_chart_release_name"></a> [helm\_chart\_release\_name](#input\_helm\_chart\_release\_name) | Helm release name | `string` | `"aws-load-balancer-controller"` | no |
| <a name="input_helm_chart_repo"></a> [helm\_chart\_repo](#input\_helm\_chart\_repo) | AWS Load Balancer Controller repository name. | `string` | `"https://aws.github.io/eks-charts"` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Metrics Server Helm chart version. | `string` | `"1.4.6"` | no |
| <a name="input_iam_oidc_provider"></a> [iam\_oidc\_provider](#input\_iam\_oidc\_provider) | AWS EKS IRSA provider | <pre>object({<br>    url = string<br>    arn = string<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name is the prefix to use for resources that needs to be created. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to deploy AWS Load Balancer Controller Helm chart. | `string` | `"kube-system"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->