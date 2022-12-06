# Label Studio AWS EKS Terraform Module

## Terraform Resources created

TODO: create resources as a table with columns: name, type
terraform-docs?

# FAQ

You will need to purchase or use an already purchased domain in Route53. The domain name and zone ID will need to be set
in the `domain_name` and `zone_id` variables in layer1.

By default, the variable `create_acm_certificate` is set to `false`. Which instructs terraform to search ARN of an
existing ACM certificate. Set to `true` if you want to create a new ACM SSL certificate using terraform .