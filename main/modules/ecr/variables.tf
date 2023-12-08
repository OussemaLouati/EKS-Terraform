variable "cluster-name" {
  type        = string
  description = "EKS Cluster name"
}

variable "project-prefix" {
  description = "Project prefix"
  type        = string
}

variable "Environment" {
  description = "Environment name."
  type        = string
}

variable "aws-region" {
  type        = string
  description = "AWS Region. "
}

variable "repository-names" {
  type        = list(string)
  description = "ECR repositories to create "
}

variable "enabled" {
  type        = string
  description = "Enable/disable the whole module "
}