<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment where infrastructure is being built | `string` | n/a | yes |
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | Metrics Server Helm chart name to be installed | `string` | `"metrics-server"` | no |
| <a name="input_helm_chart_release_name"></a> [helm\_chart\_release\_name](#input\_helm\_chart\_release\_name) | Helm release name | `string` | `"metrics-server"` | no |
| <a name="input_helm_chart_repo"></a> [helm\_chart\_repo](#input\_helm\_chart\_repo) | Metrics Server repository name | `string` | `"https://charts.bitnami.com/bitnami"` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Metrics Server Helm chart version | `string` | `"6.2.17"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to deploy Metrics Server Helm chart | `string` | `"monitoring"` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values | `map` | <pre>{<br>  "apiService": {<br>    "create": true<br>  },<br>  "extraArgs": [<br>    "--kubelet-insecure-tls=true",<br>    "--kubelet-preferred-address-types=InternalIP"<br>  ]<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->