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
  region = var.aws-region
}


# Configure the second AWS Provider
provider "aws" {
  #count = var.crossAccountBackupEnabled ? 1 : 0
  alias  = "backup"
  region = var.aws-region
  # access_key = var.target-account-access-key
  # secret_key = var.target-account-secret-key
  # token = var.target-account-session-token
}