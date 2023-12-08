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


variable "enabled" {
  description = "Enable/disable module"
  type        = bool
}


# K8S resources config
variable "runner-token" {
  description = "Token to subscribe the  gitlab runner"
  type        = string
}

variable "runner-enabled" {
  description = "Add a gitlab runner"
  type        = bool
}

variable "runner-tag" {
  description = "Runner tag"
  type        = string
}

variable "project-namespace" {
  description = "Token to subscribe the  gitlab runner"
  type        = string
}


variable "service-account-name" {
  description = "Token to subscribe the  gitlab runner"
  type        = string
}

variable "cluster-endpoint" {
  description = "Token to subscribe the  gitlab runner"
  type        = string
}

variable "cluster-name" {
  description = "Token to subscribe the  gitlab runner"
  type        = string
}


variable "node-role-name" {
  description = "Node role name"
  type        = string
}

variable "cluster-cert-auth" {
  description = "Token to subscribe the  gitlab runner"
  type        = string
}

variable "cluster-oidc-issuer" {
  description = "Token to subscribe the  gitlab runner"
  type        = string
}


# RDS config
variable "db" {
  type = object({
    secret-name = optional(string)
    enabled     = optional(bool)
    db-name     = optional(string)
    host        = optional(string)
    username    = optional(string)
    password    = optional(string)
  })
}



# Auth0 config
variable "auth0" {
  type = object({
    Auth0__domain                     = optional(string)
    Auth0__clientId                   = optional(string)
    Auth0__clientSecret               = optional(string)
    Auth0__audience                   = optional(string)
    Auth0__audienceManagement                = optional(string)
    Auth0__clientIdManagement                = optional(string)
    Auth0__clientSecretManagement            = optional(string)
  })
}

variable "aws-region" {
  type        = string
  description = "AWS Region "
}

variable "bucket-arns" {
  type        = list(string)
  description = "ARN of the S3 buckets associated with the project "
}

variable "queue-arn" {
  type        = string
  description = "ARN of the SQS queues associated with the project"
}



variable "alb-service-account-name" {
  description = "ALB SA name"
  type        = string
}
variable "alb-namespace" {
  description = "ALB controller namespace"
  type        = string
}
variable "alb-enabled" {
  description = "Enable ALB"
  type        = bool
}


variable "vpc-id" {
  type        = string
  description = "VPC ID"
}


variable "dns-enabled" {
  description = "Enable DNS"
  type        = bool
}

variable "dns-service-account-name" {
  type        = string
  description = "External DNS SA"
}

variable "domain" {
  description = "Registred Domain name"
  type        = string
}

variable "dns-namespace" {
  description = "External DNS controller namespace"
  type        = string
}


variable "create_aws_auth_configmap" {
  description = "Create aws auth config map"
  type        = bool
}

variable "aws-auth-users" {
  description = "Users to be granted access to the cluster"
  type        = list(string)
}

variable "node-role-arn" {
  type        = string
  description = "Nodes ARN"
}


variable "efs-service-account-name" {
  description = "EFS SA name"
  type        = string
}
variable "efs-namespace" {
  description = "EFS controller namespace"
  type        = string
}
variable "efs-enabled" {
  description = "Enable EFS"
  type        = bool
}

variable "private-subnet-ids" {
  type        = list(string)
  description = "EKS cluster private subnets ids"
}

variable "db-subnets-ids" {
  type        = list(string)
  description = "RDS subnets"
}

variable "harbor-username" {
  description = "Helm private repo username"
  type        = string
}

variable "harbor-password" {
  description = "Helm private repo password"
  type        = string
}

variable "git-username" {
  description = "Git private repo username"
  type        = string
}

variable "git-password" {
  description = "Git private repo password"
  type        = string
}



variable "bucket-names" {
  description = "Buckets names created by this terraform script"
  type        = list(string)
}

variable "backup-bucket" {
  description = "Bucket to use for backups"
  type        = string
}

variable "tls-crt" {
  description = "TLS cert .crt"
  type        = string
}

variable "tls-key" {
  description = "TLS cert .key"
  type        = string
}


variable "credentials" {
  type = object({
    adobe = object({
      accountId        = optional(string)
      clientId        = optional(string)
      clientSecret        = optional(string)
      orgId        = optional(string)
    })
    rabbitmq = object({
      rabbitmq-password        = optional(string)
      rabbitmq-erlang-cookie   = optional(string)
    })
    pusher = object({
      Cluster = optional(string)
      Encrypted =  optional(string)
      AppId = optional(string)
      AppKey = optional(string)
      AppSecret = optional(string)
      DefaultEventName = optional(string)
      DefaultChannelName = optional(string)
    })
  })
}

    
variable "gp3-service-account-name" {
  description = "gp3 SA name"
  type        = string
}
variable "gp3-namespace" {
  description = "gp3 controller namespace"
  type        = string
}
variable "gp3-enabled" {
  description = "Enable gp3"
  type        = bool
}