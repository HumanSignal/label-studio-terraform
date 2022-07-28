terraform {
  required_version = "~> 1.2.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.23.0"
    }
  }
}

provider "aws" {
  region = var.region
}
