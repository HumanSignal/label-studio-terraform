# Label Studio Terraform examples
This folder contains configuration examples for different use-cases to provision Label Studio/Label Studio Enterprise.

# Use-cases

## Label Studio with PostgresSQL Helm sub-chart

TODO: 
- description
- usage example with command

## Label Studio with domain name
Deploy and assign domain name with singed by Let's Encrypt certificate using cert-manager.

If you already have Hosted Zone, set `create_r53_zone` to `false`.

```hcl
create_r53_zone = false
domain_name     = "example.com"
record_name     = "label-studio"
email           = "test@test.com"
```

## Label Studio Enterprise
Deploys a Label Studio Enterprise with Elasticache and RDS
```hcl
enterprise                  = true
license_literal             = "<SECRET>"
registry_username           = "<SECRET>"
registry_password           = "<SECRET>"
label_studio_additional_set = {
  "global.image.repository" = "heartexlabs/label-studio-enterprise"
  "global.image.tag"        = "<SECRET>"
}
```
