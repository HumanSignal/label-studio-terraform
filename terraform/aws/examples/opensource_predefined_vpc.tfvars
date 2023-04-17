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
predefined_vpc = {
  id                 = "vpc-***",
  subnet_public_ids  = ["subnet-***", "subnet-***", "subnet-***"],
  subnet_private_ids = ["subnet-***", "subnet-***", "subnet-***"],
}
