required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "6.27.0"
  }
  vault = {
    source  = "hashicorp/vault"
    version = "5.6.0"
  }
  kubernetes = {
    source  = "hashicorp/kubernetes"
    version = "3.0.1"
  }
  helm = {
    source  = "hashicorp/helm"
    version = "3.1.1"
  }
  time = {
    source  = "hashicorp/time"
    version = "0.13.1"
  }
}

provider "aws" "this" {
  config {
    region     = var.region
    access_key = var.AWS_ACCESS_KEY_ID
    secret_key = var.AWS_SECRET_ACCESS_KEY
    token      = var.AWS_SESSION_TOKEN
  }
}

provider "helm" "this" {
  config {
    kubernetes = {
      host                   = component.eks_context.cluster_endpoint
      cluster_ca_certificate = base64decode(component.eks_context.cluster_certificate_authority_data)
      token                  = component.eks_context.token
    }
  }
}

provider "kubernetes" "this" {
  config {
    host                   = component.eks_context.cluster_endpoint
    cluster_ca_certificate = base64decode(component.eks_context.cluster_certificate_authority_data)
    token                  = component.eks_context.token
  }
}

provider "vault" "this" {
  config {
    address         = component.vault_runtime.vault_loadbalancer_hostname
    token           = component.vault_runtime.vault_root_token
    skip_tls_verify = true
  }
}

provider "time" "this" {}
