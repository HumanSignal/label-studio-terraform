#######################################
## OpenSource w/ external PostgreSQL ##
#######################################

environment = "demo"
name        = "ls"
region      = "eu-north-1"

label_studio_additional_set = {
  "global.image.repository" = "heartexlabs/label-studio"
  "global.image.tag"        = "develop"
}

# Postgres
postgresql_type     = "external"
postgresql_database = "<REPLACE_ME>"
postgresql_host     = "<REPLACE_ME>"
postgresql_port     = "<REPLACE_ME>"
postgresql_username = "<REPLACE_ME>"
postgresql_password = "<REPLACE_ME>"
postgresql_ssl_mode = "verify-ca"
postgresql_tls_key_file = "<REPLACE_ME>/postgres.key"
postgresql_tls_crt_file = "<REPLACE_ME>/postgres.crt"
postgresql_ca_crt_file = "<REPLACE_ME>/postgresCA.crt"
