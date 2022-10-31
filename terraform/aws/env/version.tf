terraform {
  required_version = "~> 1.3.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.7.1"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" # TODO: Make configurable
  }
}
