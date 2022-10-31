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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.14.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  config_path    = "~/.kube/config" # TODO: Make configurable
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" # TODO: Make configurable
  }
}
