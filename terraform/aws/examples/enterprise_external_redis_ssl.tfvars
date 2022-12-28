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
label_studio_registry_username = "<SECRET>"
label_studio_registry_password = "<SECRET>"

# Redis
redis_type = "external"
redis_host = "rediss://<REPLACE_ME>:<REPLACE_ME>/1"
redis_password = "<SECRET>"
redis_ssl_mode = "required"
redis_tls_key_file = "<REPLACE_ME>/redis.key"
redis_tls_crt_file = "<REPLACE_ME>/redis.crt"
redis_ca_crt_file = "<REPLACE_ME>/redisCA.crt"

label_studio_additional_set = {
  "global.image.repository" = "heartexlabs/label-studio-enterprise"
  "global.image.tag"        = "2.3.1-2"
}
############ End of Mandatory block for LSE ############
