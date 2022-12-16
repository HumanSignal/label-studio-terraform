###########################
## OpenSource w/ AWS RDS ##
###########################

environment = "demo"
name        = "ls"
region      = "eu-north-1"

label_studio_additional_set = {
  "global.image.repository" = "heartexlabs/label-studio"
  "global.image.tag"        = "develop"
}

# Postgres
postgresql_type     = "rds"
postgresql_database = "<REPLACE_ME>"
postgresql_username = "<REPLACE_ME>"
