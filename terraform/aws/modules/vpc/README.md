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
| [aws_cloudwatch_log_group.vpc_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eip.mod_nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.internet_gateway_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_nat_gateway_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.availability_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_vpc_log"></a> [enable\_vpc\_log](#input\_enable\_vpc\_log) | Enable VPC log | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment where infrastructure is being built | `string` | n/a | yes |
| <a name="input_multi_az_nat_gateway"></a> [multi\_az\_nat\_gateway](#input\_multi\_az\_nat\_gateway) | place a NAT gateway in each AZ | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name is the prefix to use for resources that needs to be created | `string` | n/a | yes |
| <a name="input_predefined_vpc_id"></a> [predefined\_vpc\_id](#input\_predefined\_vpc\_id) | Predefined VPC ID | `string` | n/a | yes |
| <a name="input_private_cidr_block"></a> [private\_cidr\_block](#input\_private\_cidr\_block) | List of private subnet CIDR blocks | `list(string)` | n/a | yes |
| <a name="input_public_cidr_block"></a> [public\_cidr\_block](#input\_public\_cidr\_block) | List of public subnet CIDR blocks | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region in where terraform builds resources | `string` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | use a single NAT gateway to serve outbound traffic for all AZs | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags to attach all the resources create in this project. | `map(string)` | `{}` | no |
| <a name="input_traffic_type"></a> [traffic\_type](#input\_traffic\_type) | The type of traffic to capture | `string` | `"ALL"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | Virtual Private Cloud CIDR block | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#input\_vpc\_enable\_dns\_hostnames) | n/a | `bool` | `"true"` | no |
| <a name="input_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#input\_vpc\_enable\_dns\_support) | n/a | `bool` | `"true"` | no |
| <a name="input_vpc_instance_tenancy"></a> [vpc\_instance\_tenancy](#input\_vpc\_instance\_tenancy) | Optional Variables # Exposed VPC Settings. | `string` | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_eip_nat_ips"></a> [aws\_eip\_nat\_ips](#output\_aws\_eip\_nat\_ips) | Output attribute of the Elastic IP. |
| <a name="output_aws_nat_gateway_count"></a> [aws\_nat\_gateway\_count](#output\_aws\_nat\_gateway\_count) | Output attributes of the NAT gateway |
| <a name="output_aws_nat_gateway_ids"></a> [aws\_nat\_gateway\_ids](#output\_aws\_nat\_gateway\_ids) | n/a |
| <a name="output_aws_route_table_private_ids"></a> [aws\_route\_table\_private\_ids](#output\_aws\_route\_table\_private\_ids) | n/a |
| <a name="output_aws_route_table_public_ids"></a> [aws\_route\_table\_public\_ids](#output\_aws\_route\_table\_public\_ids) | Output attributes of the route table ids. |
| <a name="output_aws_subnet_private_ids"></a> [aws\_subnet\_private\_ids](#output\_aws\_subnet\_private\_ids) | n/a |
| <a name="output_aws_subnet_public_ids"></a> [aws\_subnet\_public\_ids](#output\_aws\_subnet\_public\_ids) | Output attributes of the public and private subnets |
| <a name="output_aws_vpc_id"></a> [aws\_vpc\_id](#output\_aws\_vpc\_id) | Output attribute id of the VPC |
<!-- END_TF_DOCS -->