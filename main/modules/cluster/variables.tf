# Variables Configuration

# Global variables 
variable "project-prefix" {
  description = "Project prefix"
  type        = string
}

variable "project-name" {
  description = "Project Name"
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

# EKS Cluster Object config
variable "cluster" {
  type = object({
    cluster-name = string
    k8s-version  = string

    network = object({
      region          = string
      vpc             = string
      azs             = list(string)
      private-subnets = list(string)
      public-subnets  = list(string)
    })

    nodes = list(object({
      instance-type = string
      ami_type      = optional(string)
      node-count    = number
      max           = number
      min           = number
      taints = optional(map(string))
      labels = optional(map(string))
    }))
    
   
  })
}

# RDS config
variable "db" {
  type = object({
    enabled               = bool
    db-name               = string
    engine                = string
    engine-version        = string
    instance-class        = string
    username              = string
    password              = string
    allocated-storage     = number
    max-allocated-storage = number
    subnets               = list(string)
    backup-enabled        = bool
    recoverFrom = object({
      snapshotName     = optional(string)
      type             = optional(string)
      bucket_name      = optional(string)
      bucket_prefix    = optional(string)
    })
    
  })
}

variable "bastion-enabled" {
  description = "Variable to specify if bastion host was created or not"
  type        = bool
}


variable "bastion-sec-group-id" {
  description = "Bastion security group id if it exists"
  type        = string
}


variable "ingestion-role" {
  description = "Role to assume when downloading the snapshot from s3"
  type        = string
}