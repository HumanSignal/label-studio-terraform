#######################################
## Enterprise w/ RDS and Elasticache ##
#######################################

environment = "demo2"
name        = "lse"
region      = "eu-north-1"

# Postgres
postgresql_type     = "rds"
postgresql_database = "labelstudiodatabase"
postgresql_username = "labelstudio"
postgresql_password = "<SECRET>"

############ Mandatory block for LSE ############
enterprise      = true
license_literal = "<SECRET>"

# Docker private registry credentials
label_studio_docker_registry_username = "<SECRET>"
label_studio_docker_registry_password = "<SECRET>"

# Redis
redis_type     = "elasticache"
redis_password = "<SECRET>"

label_studio_additional_set = {
  "global.image.repository" = "heartexlabs/label-studio-enterprise"
  "global.image.tag"        = "2.3.1-2"
}
############ End of Mandatory block for LSE ############
