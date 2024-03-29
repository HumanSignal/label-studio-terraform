##################################
## OpenSource w/ Predefined VPC ##
##################################

environment = "demo"
name        = "ls"
region      = "eu-north-1"

label_studio_additional_set = {
  "global.image.repository" = "heartexlabs/label-studio"
  "global.image.tag"        = "develop"
}

# Predefined VPC
predefined_vpc_id = "vpc-***"
