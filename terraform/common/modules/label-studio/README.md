<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.label_studio](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.certificate](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.heartex_pull_key](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.license](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.postgresql](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.redis](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_set"></a> [additional\_set](#input\_additional\_set) | Additional sets for Label Studio Helm chart release | `map(string)` | `{}` | no |
| <a name="input_certificate_issuer_name"></a> [certificate\_issuer\_name](#input\_certificate\_issuer\_name) | Cluster Issuer name to create certificate with | `string` | n/a | yes |
| <a name="input_enterprise"></a> [enterprise](#input\_enterprise) | Deploy enterprise version of Label Studio | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment where infrastructure is being built | `string` | n/a | yes |
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | Label Studio Helm chart name to be installed | `string` | `"label-studio"` | no |
| <a name="input_helm_chart_release_name"></a> [helm\_chart\_release\_name](#input\_helm\_chart\_release\_name) | Helm release name | `string` | `"label-studio"` | no |
| <a name="input_helm_chart_repo"></a> [helm\_chart\_repo](#input\_helm\_chart\_repo) | Heartex repository name | `string` | `"https://charts.heartex.com/"` | no |
| <a name="input_helm_chart_repo_password"></a> [helm\_chart\_repo\_password](#input\_helm\_chart\_repo\_password) | Password for HTTP basic authentication against the Helm repository | `string` | n/a | yes |
| <a name="input_helm_chart_repo_username"></a> [helm\_chart\_repo\_username](#input\_helm\_chart\_repo\_username) | Username for HTTP basic authentication against the Helm repository | `string` | n/a | yes |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Label Studio Helm chart version | `string` | `"1.0.0"` | no |
| <a name="input_host"></a> [host](#input\_host) | Label Studio fqdn | `string` | n/a | yes |
| <a name="input_license_literal"></a> [license\_literal](#input\_license\_literal) | License link for enterprise Label Studio | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name is the prefix to use for resources that needs to be created | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to deploy Label Studio Helm chart | `string` | `"labelstudio"` | no |
| <a name="input_postgresql"></a> [postgresql](#input\_postgresql) | Postgresql type | `string` | `"internal"` | no |
| <a name="input_postgresql_database"></a> [postgresql\_database](#input\_postgresql\_database) | Postgresql database name | `string` | `"labelstudio"` | no |
| <a name="input_postgresql_host"></a> [postgresql\_host](#input\_postgresql\_host) | Postgresql fqdn | `string` | `""` | no |
| <a name="input_postgresql_password"></a> [postgresql\_password](#input\_postgresql\_password) | Postgresql password | `string` | `"labelstudio"` | no |
| <a name="input_postgresql_port"></a> [postgresql\_port](#input\_postgresql\_port) | Postgresql port | `number` | `5432` | no |
| <a name="input_postgresql_username"></a> [postgresql\_username](#input\_postgresql\_username) | Postgresql username | `string` | `"labelstudio"` | no |
| <a name="input_redis"></a> [redis](#input\_redis) | Redis type | `string` | `"internal"` | no |
| <a name="input_redis_host"></a> [redis\_host](#input\_redis\_host) | Redis fqdn | `string` | n/a | yes |
| <a name="input_redis_password"></a> [redis\_password](#input\_redis\_password) | Redis password | `string` | n/a | yes |
| <a name="input_registry_email"></a> [registry\_email](#input\_registry\_email) | Docker email to pull label studio image | `string` | `""` | no |
| <a name="input_registry_password"></a> [registry\_password](#input\_registry\_password) | Docker password to pull label studio image. | `string` | `""` | no |
| <a name="input_registry_server"></a> [registry\_server](#input\_registry\_server) | Docker registry fqdn to pull label studio image from | `string` | `"https://index.docker.io/v2/"` | no |
| <a name="input_registry_username"></a> [registry\_username](#input\_registry\_username) | Docker username to pull label studio image | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_host"></a> [host](#output\_host) | n/a |
<!-- END_TF_DOCS -->