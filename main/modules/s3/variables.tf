# Variables Configuration

# Global variables 
variable "project-prefix" {
  description = "Project prefix"
  type        = string
}


variable "account-id" {
  description = "Account ID"
  type        = string
}

variable "Environment" {
  description = "Environemnt name."
  type        = string
}

variable "aws-region" {
  type        = string
  description = "AWS Region "
}

variable "cluster-name" {
  type        = string
  description = "EKS Cluster name"
}

variable "bucket-names" {
  type        = list(string)
  description = "S3 buckets to create "
}

variable "enabled" {
  type        = string
  description = "Enable/disable the whole module "
}

variable "crossAccountBackupEnabled" {
  type        = bool
  description = "Enable/disable cross account replication "
}

variable "target-account-id" {
  type        = string
  description = "Target account id "
}

variable "target-account-access-key" {
  type        = string
  description = "target account acceess key "
}

variable "target-account-secret-key" {
  type        = string
  description = "target account secret key  "
}
 
variable "target-account-session-token" {
  type        = string
  description = "target account session token  "
}

variable "queue-arn" {
  type        = string
  description = "ARN of the SQS queues associated with the project"
}
