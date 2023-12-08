terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }

  }

  #required_version = ">= 0.14.9"
}


# Configure the AWS Provider
provider "aws" {
  region = var.cluster.network.region
}

