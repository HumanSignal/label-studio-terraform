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
| [helm_release.label_studio](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.heartex_pull_key](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.license](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.postgresql](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.postgresql-ssl-cert](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.redis](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.redis-ssl-cert](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_set"></a> [additional\_set](#input\_additional\_set) | Additional sets for Label Studio Helm chart release | `map(string)` | `{}` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider | `string` | `""` | no |
| <a name="input_docker_registry_email"></a> [docker\_registry\_email](#input\_docker\_registry\_email) | Docker email to pull Label Studio image | `string` | `""` | no |
| <a name="input_docker_registry_password"></a> [docker\_registry\_password](#input\_docker\_registry\_password) | Docker password to pull Label Studio image. | `string` | `""` | no |
| <a name="input_docker_registry_server"></a> [docker\_registry\_server](#input\_docker\_registry\_server) | Docker Registry Hub | `string` | `"https://index.docker.io/v2/"` | no |
| <a name="input_docker_registry_username"></a> [docker\_registry\_username](#input\_docker\_registry\_username) | Docker username to pull Label Studio image | `string` | `""` | no |
| <a name="input_enterprise"></a> [enterprise](#input\_enterprise) | Deploy enterprise version of Label Studio | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment where infrastructure is being built | `string` | n/a | yes |
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | Label Studio Helm chart name to be installed | `string` | `"label-studio"` | no |
| <a name="input_helm_chart_release_name"></a> [helm\_chart\_release\_name](#input\_helm\_chart\_release\_name) | Helm release name | `string` | `"label-studio"` | no |
| <a name="input_helm_chart_repo"></a> [helm\_chart\_repo](#input\_helm\_chart\_repo) | Heartex repository name | `string` | `"https://charts.heartex.com/"` | no |
| <a name="input_helm_chart_repo_password"></a> [helm\_chart\_repo\_password](#input\_helm\_chart\_repo\_password) | Password for HTTP basic authentication against the Helm repository | `string` | `""` | no |
| <a name="input_helm_chart_repo_username"></a> [helm\_chart\_repo\_username](#input\_helm\_chart\_repo\_username) | Username for HTTP basic authentication against the Helm repository | `string` | `""` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Label Studio Helm chart version | `string` | `"1.0.16"` | no |
| <a name="input_host"></a> [host](#input\_host) | Label Studio fqdn | `string` | n/a | yes |
| <a name="input_license_literal"></a> [license\_literal](#input\_license\_literal) | License link for enterprise Label Studio | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name is the prefix to use for resources that needs to be created | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to deploy Label Studio Helm chart | `string` | `"labelstudio"` | no |
| <a name="input_persistence_s3_bucket_folder"></a> [persistence\_s3\_bucket\_folder](#input\_persistence\_s3\_bucket\_folder) | TBD | `string` | `""` | no |
| <a name="input_persistence_s3_bucket_name"></a> [persistence\_s3\_bucket\_name](#input\_persistence\_s3\_bucket\_name) | TBD | `string` | n/a | yes |
| <a name="input_persistence_s3_bucket_region"></a> [persistence\_s3\_bucket\_region](#input\_persistence\_s3\_bucket\_region) | TBD | `string` | n/a | yes |
| <a name="input_persistence_s3_role_arn"></a> [persistence\_s3\_role\_arn](#input\_persistence\_s3\_role\_arn) | TBD | `string` | n/a | yes |
| <a name="input_postgresql_ca_crt_file"></a> [postgresql\_ca\_crt\_file](#input\_postgresql\_ca\_crt\_file) | n/a | `string` | `null` | no |
| <a name="input_postgresql_database"></a> [postgresql\_database](#input\_postgresql\_database) | Postgresql database name | `string` | `"labelstudio"` | no |
| <a name="input_postgresql_host"></a> [postgresql\_host](#input\_postgresql\_host) | Postgresql fqdn | `string` | `""` | no |
| <a name="input_postgresql_password"></a> [postgresql\_password](#input\_postgresql\_password) | Postgresql password | `string` | `"labelstudio"` | no |
| <a name="input_postgresql_port"></a> [postgresql\_port](#input\_postgresql\_port) | Postgresql port | `number` | `5432` | no |
| <a name="input_postgresql_ssl_mode"></a> [postgresql\_ssl\_mode](#input\_postgresql\_ssl\_mode) | n/a | `string` | `"require"` | no |
| <a name="input_postgresql_tls_crt_file"></a> [postgresql\_tls\_crt\_file](#input\_postgresql\_tls\_crt\_file) | n/a | `string` | `null` | no |
| <a name="input_postgresql_tls_key_file"></a> [postgresql\_tls\_key\_file](#input\_postgresql\_tls\_key\_file) | n/a | `string` | `null` | no |
| <a name="input_postgresql_type"></a> [postgresql\_type](#input\_postgresql\_type) | Postgresql type | `string` | `"internal"` | no |
| <a name="input_postgresql_username"></a> [postgresql\_username](#input\_postgresql\_username) | Postgresql username | `string` | `"labelstudio"` | no |
| <a name="input_redis_ca_crt_file"></a> [redis\_ca\_crt\_file](#input\_redis\_ca\_crt\_file) | n/a | `string` | `null` | no |
| <a name="input_redis_host"></a> [redis\_host](#input\_redis\_host) | Redis fqdn | `string` | n/a | yes |
| <a name="input_redis_password"></a> [redis\_password](#input\_redis\_password) | Redis password | `string` | n/a | yes |
| <a name="input_redis_ssl_mode"></a> [redis\_ssl\_mode](#input\_redis\_ssl\_mode) | n/a | `string` | `"required"` | no |
| <a name="input_redis_tls_crt_file"></a> [redis\_tls\_crt\_file](#input\_redis\_tls\_crt\_file) | n/a | `string` | `null` | no |
| <a name="input_redis_tls_key_file"></a> [redis\_tls\_key\_file](#input\_redis\_tls\_key\_file) | n/a | `string` | `null` | no |
| <a name="input_redis_type"></a> [redis\_type](#input\_redis\_type) | Redis deployment type | `string` | `"internal"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_host"></a> [host](#output\_host) | n/a |
<!-- END_TF_DOCS -->