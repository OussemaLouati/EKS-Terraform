# Variables Configuration

# Cluster 
variable "cluster-name" {
  type        = string
  description = "EKS Cluster name"
}

variable "aws-region" {
  type        = string
  description = "AWS Region "
}

variable "project-prefix" {
  description = "Project prefix"
  type        = string
}

variable "Environment" {
  description = "Environemnt name."
  type        = string
}

variable "queue-names" {
  type        = list(string)
  description = "SQS queues to create "
}

variable "enabled" {
  type        = string
  description = "Enable/disable the whole module "
}

variable "bucket-arns" {
  type        = list(string)
  description = "ARN of the S3 buckets associated with the project "
}