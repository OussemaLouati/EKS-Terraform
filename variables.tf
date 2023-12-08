# Variables Configuration

# Global 
variable "project_prefix" {
  description = "Project prefix"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "account_id" {
  description = "Account ID"
  type        = string
}

variable "Environment" {
  description = "Environment name."
  type        = string
}



# Cluster 
variable "cluster_name" {
  type        = string
}

variable "aws_region" {
  type        = string
}

variable "availability_zone_1" {
  type        = string
}

variable "availability_zone_2" {
  type        = string
}

variable "k8s_version" {
  type        = string
  description = "K8s version"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "eks_private_subnet_1" {
  type        = string
  description = "EKS cluster private subnets"
}

variable "eks_private_subnet_2" {
  type        = string
  description = "EKS cluster private subnets"
}

variable "eks_public_subnet_1" {
  type        = string
  description = "EKS cluster private subnets"
}

variable "eks_public_subnet_2" {
  type        = string
  description = "EKS cluster private subnets"
}

variable "node_group_1_instance_type" {
  type        = string
  description = "Node pools 1"
}

variable "node_group_2_instance_type" {
  type        = string
  description = "Node pools 1"
}

variable "node_group_3_instance_type" {
  type        = string
  description = "Node pools 1"
}


####### Database #######
variable "db_private_subnet_1" {
  type        = string
  description = "RDS private subnets"
}

variable "db_private_subnet_2" {
  type        = string
  description = "RDS private subnets"
}

variable "db_name" {
  description = "Database name."
  type        = string
}

variable "engine" {
  description = "Database engine."
  type        = string
}

variable "engine_version" {
  description = "Database engine version."
  type        = string
}
variable "instance_class" {
  description = "Database instance class."
  type        = string
}

variable "username" {
  description = "Database Username."
  type        = string
}

variable "password" {
  description = "Database Password."
  type        = string
}

variable "allocated_storage" {
  description = "Database allocated storage."
  type        = string
}
variable "max_allocated_storage" {
  description = "Database autoscaling Max allocated storage."
  type        = string
}

# K8S Resources
variable "runner_token" {
  description = "Token to subscribe the  gitlab runner"
  type        = string
}

variable "runner_tag" {
  description = "Tag to use for the gitlab runner"
  type        = string
}


variable "project_namespace" {
  description = "K8s default namespace for  deployment"
  type        = string
}

variable "main_service_account_name" {
  description = "jf"
  type        = string
}

variable "alb_service_account_name" {
  description = "jf"
  type        = string
}

variable "dns_service_account_name" {
  description = "jf"
  type        = string
}

variable "domain" {
  description = "jf"
  type        = string
}


variable "db_secret_name" {
  description = "jf"
  type        = string
}


# Bastion host variables
variable "ec2_public_key" {
  type        = string
  description = "SSH Public key "
}

variable "bastion_ingress_cidr_blocks" {
  type        = string
  description = "Bastion host inbound rule "
}


variable "bastion_instance_type" {
  type        = string
  description = "Bastion instance type "
}

variable "bastion_image_ami" {
  type        = string
  description = "Bastion image ami "
}
variable "bastion_volume_size" {
  type        = number
  description = "Bastion volume size "
}
variable "bastion_volume_type" {
  type        = string
  description = "Bastion volume type "
}
variable "bastion_min_size" {
  type        = number
  description = "Bastion min count "
}
variable "bastion_max_size" {
  type        = number
  description = "Bastion max count "
}
variable "bastion_size" {
  type        = number
  description = "Bastion desired count "
}


variable "authenticated_user_1" {
  type        = string
  description = "List of users "
}

variable "authenticated_user_2" {
  type        = string
  description = "List of users "
}

variable "ecr_repository_api" {
  type        = string
  description = "List of ECR repositories "
}

variable "ecr_repository_data_api" {
  type        = string
  description = "List of ECR repositories "
}

variable "ecr_repository_core_ml" {
  type        = string
  description = "List of ECR repositories "
}

variable "ecr_repository_web" {
  type        = string
  description = "List of ECR repositories "
}

variable "harbor_username" {
  description = "Helm private repo username"
  type        = string
}

variable "harbor_password" {
  description = "Helm private repo password"
  type        = string
}

variable "git_username" {
  description = "Git private repo username"
  type        = string
}

variable "git_password" {
  description = "Git private repo password"
  type        = string
}

variable "target_account_id" {
  type        = string
  description = "Target account id "
  default = ""
}

variable "target_account_access_key" {
  type        = string
  description = "target account acceess key "
  default = ""
}

variable "target_account_secret_key" {
  type        = string
  description = "target account secret key  "
  default = ""
}
 
variable "target_account_session_token" {
  type        = string
  description = "target account session token  "
  default = ""
}

variable "auth0Domain" {
  type        = string
  description = "auth0 config  "
}
variable "clientId" {
  type        = string
  description = "auth0 config  "
}
variable "clientSecret" {
  type        = string
  description = "auth0 config"
}
variable "audience" {
  type        = string
  description = "auth0 config  "
}

variable "audienceManagement" {
  type        = string
  description = "auth0 config  "
}

variable "clientIdManagement" {
  type        = string
  description = "auth0 config  "
}
variable "clientSecretManagement" {
  type        = string
  description = "auth0 config  "
}
 

# variable "AAppId" {
#   type        = string
#   description = "auth0 config  "
# }
# variable "SeedOptionsOrganizations" {
#   type        = string
#   description = "auth0 config  "
# }
# variable "SeedOptionsEnabled" {
#   type        = string
#   description = "auth0 config  "
# }

# variable "ApiKeysKeysName" {
#   type        = string
#   description = "auth0 config  "
# }
# variable "ApiKeysKeysKey" {
#   type        = string
#   description = "auth0 config  "
# }
# variable "SeedOptionsDefaultOrganization" {
#   type        = string
#   description = "auth0 config  "
# }
# variable "workerApiKey" {
#   type        = string
#   description = "auth0 config  "
# }
# variable "schedulerApiKey" {
#   type        = string
#   description = "auth0 config  "
# }

variable "tls_crt" {
  description = "TLS cert .crt"
  type        = string
}

variable "tls_key" {
  description = "TLS cert .key"
  type        = string
}

### Credentials
    ### adobe

variable "accountId" {
  description = "adobe account"
  type        = string
}
variable "adobeClientId" {
  description = "adobe client id"
  type        = string
}

variable "adobeClientSecret" {
  description = "adobe client secret"
  type        = string
}
variable "adobeOrgId" {
  description = "adobe org id"
  type        = string
}


    ### Rabbitmq
variable "rabbitmq_password" {
  description = "Rabbitmq password"
  type        = string
}
variable "rabbitmq_erlang_cookie" {
  description = "Rabbitmq erlang cookie"
  type        = string
}

   ### SES
# variable "accessKey" {
#   description = "Access key with permission to ses"
#   type        = string
# }
variable "senderEmail" {
  description = "Sender email to use with ses"
  type        = string
}
# variable "secretAccessKey" {
#   description = "Secret key with permission to ses"
#   type        = string
# }

# PUSHER config
variable "DefaultChannelName" {
  description = "pusher config"
  type        = string
}
variable "DefaultEventName" {
  description = "pusher config"
  type        = string
}
variable "AppSecret" {
  description = "pusher config"
  type        = string
}
variable "AppKey" {
  description = "pusher config"
  type        = string
}
variable "AppId" {
  description = "pusher config"
  type        = string
}
variable "Encrypted" {
  description = "pusher config"
  type        = string
}
variable "Cluster" {
  description = "pusher config"
  type        = string
}
