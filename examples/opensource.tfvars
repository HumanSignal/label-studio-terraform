################
## OpenSource ##
################

environment = "demo"
name        = "ls"
region      = "eu-north-1"

label_studio_additional_set = {
  "global.image.repository"                                         = "heartexlabs/label-studio"
  "global.image.tag"                                                = "develop"
  "global.extraEnvironmentVars.SKIP_EMAIL_VERIFICATION_FOR_DOMAINS" = "heartex.e2e"
}
