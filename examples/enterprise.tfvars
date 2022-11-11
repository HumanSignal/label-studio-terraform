#######################################
## Enterprise w/ RDS and Elasticache ##
#######################################

environment = "demo2"
name        = "lse"
region      = "eu-north-1"

enterprise      = true
#license_literal = "<SECRET>"

# Postgres
postgresql          = "rds"
postgresql_database = "labelstudiodatabase"
postgresql_username = "labelstudio"
postgresql_password = "WOWSUCHASTRONGPASSWORD!"

# Redis
redis          = "elasticache"
redis_password = "WHOCARESABOUTREDIS?!"

label_studio_additional_set = {
  "global.image.repository"                                         = "heartexlabs/label-studio-enterprise"
  "global.image.tag"                                                = "20221107.153324-develop-cbee3a8c"
  "global.extraEnvironmentVars.SKIP_EMAIL_VERIFICATION_FOR_DOMAINS" = "heartex.e2e"
  "app.resources.requests.memory"                                   = "1200Mi"
  "app.resources.requests.cpu"                                      = "500m"
  "app.resources.limits.memory"                                     = "1500Mi"
  "app.resources.limits.cpu"                                        = "1000m"
  "rqworker.resources.requests.memory"                              = "512Mi"
  "rqworker.resources.requests.cpu"                                 = "512m"
  "rqworker.resources.limits.memory"                                = "768Mi"
  "rqworker.resources.limits.cpu"                                   = "768m"
  "rqworker.queues.high.replicas"                                   = 0
  "rqworker.queues.low.replicas"                                    = 0
  "rqworker.queues.default.replicas"                                = 0
  "rqworker.queues.critical.replicas"                               = 0
  "rqworker.queues.all.replicas"                                    = 1
}
