<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [kubernetes_service.nginx-ingress-service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_ssl_certificate"></a> [default\_ssl\_certificate](#input\_default\_ssl\_certificate) | Default SSL certificate | `string` | n/a | yes |
| <a name="input_eip_addresses"></a> [eip\_addresses](#input\_eip\_addresses) | EIP addresses list | `list` | `[]` | no |
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | Nginx Ingress Controller Helm chart name to be installed | `string` | `"ingress-nginx"` | no |
| <a name="input_helm_chart_release_name"></a> [helm\_chart\_release\_name](#input\_helm\_chart\_release\_name) | Helm release name | `string` | `"ingress-nginx"` | no |
| <a name="input_helm_chart_repo"></a> [helm\_chart\_repo](#input\_helm\_chart\_repo) | Nginx Ingress Controller repository name | `string` | `"https://kubernetes.github.io/ingress-nginx"` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Nginx Ingress Controller Helm chart version | `string` | `"4.6.0"` | no |
| <a name="input_load_balancer_name"></a> [load\_balancer\_name](#input\_load\_balancer\_name) | Load Balancer name to create | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to deploy Nginx Ingress Controller Helm chart | `string` | `"ingress-controller"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Amount of replicas | `number` | `1` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional yaml encoded values which will be passed to the Helm chart | `map` | `{}` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | Virtual Private Cloud CIDR block | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_host"></a> [host](#output\_host) | n/a |
| <a name="output_load_balancer_dns_name"></a> [load\_balancer\_dns\_name](#output\_load\_balancer\_dns\_name) | n/a |
| <a name="output_load_balancer_name"></a> [load\_balancer\_name](#output\_load\_balancer\_name) | n/a |
| <a name="output_load_balancer_zone_id"></a> [load\_balancer\_zone\_id](#output\_load\_balancer\_zone\_id) | n/a |
<!-- END_TF_DOCS -->