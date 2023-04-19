###########################################
## Only infrastructure in Predefined VPC ##
###########################################

environment = "infra"
name        = "ls"
region      = "us-east-2"

# Predefined VPC
predefined_vpc_id = "vpc-***"

deploy_label_studio = false
postgresql_type     = "external"
redis_type          = "external"
