#######################################
## Enterprise w/ RDS and Elasticache ##
#######################################

environment = "demo2"
name        = "lse"
region      = "eu-north-1"

enterprise      = true
license_literal = "<SECRET>"

# docker registry
label_studio_registry_username = "<SECRET>"
label_studio_registry_password = "<SECRET>"

# Postgres
postgresql          = "rds"
postgresql_database = "labelstudiodatabase"
postgresql_username = "labelstudio"
postgresql_password = "<SECRET>"

# Redis
redis          = "elasticache"
redis_password = "<SECRET>"

label_studio_additional_set = {
  "global.image.repository" = "heartexlabs/label-studio-enterprise"
  "global.image.tag"        = "20221107.153324-develop-cbee3a8c"
}
