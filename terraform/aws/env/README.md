<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 4.40.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.7.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | = 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | = 2.16.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | = 3.4.3 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | = 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.40.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | ../modules/acm | n/a |
| <a name="module_cert-manager"></a> [cert-manager](#module\_cert-manager) | ../../common/modules/cert-manager | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ../modules/eks | n/a |
| <a name="module_elasticache"></a> [elasticache](#module\_elasticache) | ../modules/elasticache | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ../modules/iam | n/a |
| <a name="module_label-studio"></a> [label-studio](#module\_label-studio) | ../../common/modules/label-studio | n/a |
| <a name="module_lbc"></a> [lbc](#module\_lbc) | ../modules/load-balancer-controller | n/a |
| <a name="module_nic"></a> [nic](#module\_nic) | ../../common/modules/nginx-ingress-controller | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ../modules/rds | n/a |
| <a name="module_route53"></a> [route53](#module\_route53) | ../modules/route53 | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ../modules/s3 | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.eks](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_acm_certificate"></a> [create\_acm\_certificate](#input\_create\_acm\_certificate) | Whether to create acm certificate or use existing | `bool` | `false` | no |
| <a name="input_create_r53_zone"></a> [create\_r53\_zone](#input\_create\_r53\_zone) | Create R53 zone for main public domain | `bool` | `false` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired capacity for the autoscaling Group. | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Main public domain name | `string` | `null` | no |
| <a name="input_eks_capacity_type"></a> [eks\_capacity\_type](#input\_eks\_capacity\_type) | Type of capacity associated with the EKS Node Group | `string` | `"ON_DEMAND"` | no |
| <a name="input_enterprise"></a> [enterprise](#input\_enterprise) | Deploy enterprise version of Label Studio | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment where infrastructure is being built. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of instance to be used for the Kubernetes cluster. | `string` | `"t3.medium"` | no |
| <a name="input_label_studio_additional_set"></a> [label\_studio\_additional\_set](#input\_label\_studio\_additional\_set) | Additional sets for Label Studio Helm chart release | `map(string)` | `{}` | no |
| <a name="input_label_studio_helm_chart_name"></a> [label\_studio\_helm\_chart\_name](#input\_label\_studio\_helm\_chart\_name) | Label Studio Helm chart name to be installed | `string` | `"label-studio"` | no |
| <a name="input_label_studio_helm_chart_repo"></a> [label\_studio\_helm\_chart\_repo](#input\_label\_studio\_helm\_chart\_repo) | Heartex repository name. | `string` | `"https://charts.heartex.com"` | no |
| <a name="input_label_studio_helm_chart_repo_password"></a> [label\_studio\_helm\_chart\_repo\_password](#input\_label\_studio\_helm\_chart\_repo\_password) | Password for HTTP basic authentication against the Helm repository. | `string` | `""` | no |
| <a name="input_label_studio_helm_chart_repo_username"></a> [label\_studio\_helm\_chart\_repo\_username](#input\_label\_studio\_helm\_chart\_repo\_username) | Username for HTTP basic authentication against the Helm repository. | `string` | `""` | no |
| <a name="input_label_studio_registry_email"></a> [label\_studio\_registry\_email](#input\_label\_studio\_registry\_email) | Docker email to pull Label Studio image | `string` | `""` | no |
| <a name="input_label_studio_registry_password"></a> [label\_studio\_registry\_password](#input\_label\_studio\_registry\_password) | Docker password to pull Label Studio image. | `string` | `""` | no |
| <a name="input_label_studio_registry_server"></a> [label\_studio\_registry\_server](#input\_label\_studio\_registry\_server) | Docker registry fqdn to pull Label Studio image from | `string` | `"https://index.docker.io/v2/"` | no |
| <a name="input_label_studio_registry_username"></a> [label\_studio\_registry\_username](#input\_label\_studio\_registry\_username) | Docker username to pull Label Studio image | `string` | `""` | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email address for certificate sing via Let's Encrypt | `string` | `null` | no |
| <a name="input_license_literal"></a> [license\_literal](#input\_license\_literal) | License link for enterprise Label Studio | `string` | `null` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of the instances in autoscaling group | `number` | `5` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of the instances in autoscaling group | `number` | `3` | no |
| <a name="input_name"></a> [name](#input\_name) | Name is the prefix to use for resources that needs to be created. | `string` | n/a | yes |
| <a name="input_postgresql"></a> [postgresql](#input\_postgresql) | Postgresql type | `string` | `"internal"` | no |
| <a name="input_postgresql_database"></a> [postgresql\_database](#input\_postgresql\_database) | Postgresql database name | `string` | `"labelstudio"` | no |
| <a name="input_postgresql_host"></a> [postgresql\_host](#input\_postgresql\_host) | Postgresql fqdn | `string` | `""` | no |
| <a name="input_postgresql_machine_type"></a> [postgresql\_machine\_type](#input\_postgresql\_machine\_type) | Postgresql machine type | `string` | `"db.m5.large"` | no |
| <a name="input_postgresql_password"></a> [postgresql\_password](#input\_postgresql\_password) | Postgresql password | `string` | `"labelstudio"` | no |
| <a name="input_postgresql_port"></a> [postgresql\_port](#input\_postgresql\_port) | Postgresql port | `number` | `5432` | no |
| <a name="input_postgresql_username"></a> [postgresql\_username](#input\_postgresql\_username) | Postgresql username | `string` | `"labelstudio"` | no |
| <a name="input_private_cidr_block"></a> [private\_cidr\_block](#input\_private\_cidr\_block) | List of private subnet cidr blocks | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_public_cidr_block"></a> [public\_cidr\_block](#input\_public\_cidr\_block) | List of public subnet cidr blocks | `list(string)` | <pre>[<br>  "10.0.101.0/24",<br>  "10.0.102.0/24",<br>  "10.0.103.0/24"<br>]</pre> | no |
| <a name="input_record_name"></a> [record\_name](#input\_record\_name) | Main record domain name | `string` | `null` | no |
| <a name="input_redis"></a> [redis](#input\_redis) | Redis deployment type | `string` | `"internal"` | no |
| <a name="input_redis_host"></a> [redis\_host](#input\_redis\_host) | Redis fqdn | `string` | `""` | no |
| <a name="input_redis_machine_type"></a> [redis\_machine\_type](#input\_redis\_machine\_type) | Redis machine type | `string` | `"cache.t3.micro"` | no |
| <a name="input_redis_password"></a> [redis\_password](#input\_redis\_password) | Redis password | `string` | `"labelstudio"` | no |
| <a name="input_redis_port"></a> [redis\_port](#input\_redis\_port) | Redis port | `string` | `6379` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where terraform build resources. | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Bucket Name (aka ID) |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for your EKS Kubernetes API |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the EKS cluster |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | Version of the EKS cluster |
| <a name="output_connect_cluster"></a> [connect\_cluster](#output\_connect\_cluster) | Configuring EKS cluster access for kubectl |
| <a name="output_host"></a> [host](#output\_host) | n/a |
| <a name="output_load_balancer_host"></a> [load\_balancer\_host](#output\_load\_balancer\_host) | n/a |
<!-- END_TF_DOCS -->