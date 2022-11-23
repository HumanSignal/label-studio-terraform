terraform {
  required_version = "~> 1.3.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.40.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.7.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.16.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "= 1.14.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "= 4.0.4"
    }
    random = {
      source = "hashicorp/random"
      version = "= 3.4.3"
    }
  }
}
