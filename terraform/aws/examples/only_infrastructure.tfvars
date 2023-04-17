###########################################
## Only infrastructure in Predefined VPC ##
###########################################

environment = "infra"
name        = "ls"
region      = "us-east-2"

# Predefined VPC
predefined_vpc = {
  id                 = "vpc-11111111",
  subnet_public_ids  = ["subnet-11111111", "subnet-2222222", "subnet-33333333"],
  subnet_private_ids = ["subnet-44444444", "subnet-5555555", "subnet-77777777"],
}

deploy_label_studio = false
postgresql_type     = "external"
redis_type          = "external"
