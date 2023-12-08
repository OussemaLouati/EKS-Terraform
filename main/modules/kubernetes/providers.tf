terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }

  }

  #required_version = ">= 0.14.9"
}


# Configure the AWS Provider
provider "aws" {
  region = var.aws-region
}

data "aws_eks_cluster_auth" "eks-cluster" {
  name = var.cluster-name
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  host = var.cluster-endpoint

  token                  = data.aws_eks_cluster_auth.eks-cluster.token
  cluster_ca_certificate = base64decode(var.cluster-cert-auth)
}


# Configure the Kubectl Provider
provider "kubectl" {
  host  = var.cluster-endpoint
  token = data.aws_eks_cluster_auth.eks-cluster.token
  cluster_ca_certificate = base64decode(
    var.cluster-cert-auth,
  )
  load_config_file = false
}

# Configure the Helm Provider
provider "helm" {
  kubernetes {
    host  = var.cluster-endpoint
    token = data.aws_eks_cluster_auth.eks-cluster.token
    cluster_ca_certificate = base64decode(
      var.cluster-cert-auth,
    )
  }
}