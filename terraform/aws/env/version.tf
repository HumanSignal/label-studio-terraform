terraform {
  required_version = "~> 1.3.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.38.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.7.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.15.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "= 4.0.4"
    }
  }
}
