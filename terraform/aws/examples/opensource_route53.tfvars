###########################################
## OpenSource w/ AWS Route53 domain name ##
###########################################

environment = "demo"
name        = "ls"
region      = "eu-north-1"

create_r53_zone    = true # set to false if you already have the Route53 hosted zone
domain_name        = "example.com" # hosted zone name
record_name        = "label-studio" # Label Studio subdomain
lets_encrypt_email = "test@test.com" # used for let's encrypt certificate

label_studio_additional_set = {
  "global.image.repository" = "heartexlabs/label-studio"
  "global.image.tag"        = "develop"
}
