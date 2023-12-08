# Variables Configuration

# Global 
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
  description = "Environment name."
  type        = string
}

# ECR
variable "ECR" {
  type = object({
    enabled          = bool
    repository-names = list(string)
  })
}


variable "S3" {
  type = object({
    enabled      = bool
    bucket-names = list(string)
    backup-bucket = string
  })
}

variable "aws-auth" {
  type = object({
    enabled = bool
    users   = list(string)
  })
}

variable "SQS" {
  type = object({
    enabled     = bool
    queue-names = list(string)
  })
}

# EKS Cluster Object config
variable "EKS" {
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
variable "RDS" {
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
      type             = optional(string,"SCRATCH")
      bucket_name      = optional(string)
      bucket_prefix    = optional(string)
    })

  })
}

# EKS Cluster Object config
variable "BASTION_HOST" {
  type = object({
    enabled             = bool
    name                = string
    ingress-cidr-blocks = list(string)
    ssh-key             = string

    spec = object({
      instance-type = string
      image-ami     = optional(string, "ami-0b5eea76982371e91")
      volume-size   = string
      volume-type   = string
      min-size      = number
      max-size      = number
      desired-size  = number
    })

  })
}


# K8S
variable "K8S" {
  type = object({
    enabled   = optional(bool)
    namespace = optional(string)
    main-sa   = optional(string)
    db-secret = optional(string)

    runner = object({
      enabled = optional(bool)
      token   = optional(string)
      tag     = optional(string)
    })
    
    argo-cd = object({
      harbor-username   = optional(string)
      harbor-password = optional(string)
      git-username   = optional(string)
      git-password    = optional(string)
    })

    dns = object({
      enabled   = optional(bool)
      namespace = optional(string)
      sa-name   = optional(string)
      domain    = optional(string)
    })

    alb = object({
      enabled   = optional(bool)
      namespace = optional(string)
      sa-name   = optional(string)
    })
    
    efs = object({
      enabled   = optional(bool)
      namespace = optional(string)
      sa-name   = optional(string)
      private-subnet-ids   = optional(list(string))
    })

    gp3 = object({
      enabled   = optional(bool)
      namespace = optional(string)
      sa-name   = optional(string)
    })

  })
}

variable "cross-accounts-backup" {
  type = object({
      enabled     = optional(bool,false)
      target-account-id             = optional(string)
      target-account-access-key      = optional(string)
      target-account-secret-key    = optional(string)
      target-account-session-token    = optional(string)
  })
}

variable "tls-crt" {
  description = "TLS cert .crt"
  type        = string
}

variable "tls-key" {
  description = "TLS cert .key"
  type        = string
}

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