module "main" {
  source = "./main"

  # Global config
  project-prefix = var.project_prefix 
  project-name   = var.project_name  
  account-id     = var.account_id    
  Environment    = var.Environment    

  # EKS cluster
  EKS = {
    cluster-name = var.cluster_name
    k8s-version  = var.k8s_version

    network = {
      region          = var.aws_region
      azs             = [var.availability_zone_1, var.availability_zone_2] 
      vpc             = var.vpc_cidr_block
      private-subnets = [var.eks_private_subnet_1, var.eks_private_subnet_2]
      public-subnets  = [var.eks_public_subnet_1, var.eks_public_subnet_2]
    }
    # These are example on how to define nodes 
    nodes =  [
        {
        instance-type = "c5a.8xlarge"
        min           = 0
        max           = 3
        node-count    = 0
        taints        = {
          key    = "workload/argo"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
        labels        = {
          "node-restriction.mlops.eks.com/purpose": "Argo"
        }
      },
        {
        instance-type = "p3.2xlarge"
        min           = 0
        max           = 1
        node-count    = 0
        ami_type      = "BOTTLEROCKET_x86_64_NVIDIA"
        taints        = {
          key   = "nvidia.com/gpu"
          value  = "present"
          effect = "NO_SCHEDULE"
        }
        labels        = {
          "node-restriction.mlops.eks.com/purpose": "Argo"
        }
     },
       {
        instance-type = "c5a.8xlarge"
        min           = 2
        max           = 4
        node-count    = 2
        taints        = {
          key    = "release/devBetaPublic"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
        labels        = {
          "node-restriction.mlops.eks.com/purpose": "Dev"
        }
     },

    ]
  }

  # Database config
  RDS = {
    enabled               = true
    db-name               = var.db_name
    engine                = var.engine
    engine-version        = var.engine_version
    instance-class        = var.instance_class
    username              = var.username
    password              = var.password
    allocated-storage     = var.allocated_storage
    max-allocated-storage = var.max_allocated_storage
    subnets               = [var.db_private_subnet_1, var.db_private_subnet_2]
    backup-enabled        = true
    recoverFrom           = {
      type = "SCRATCH"   # options: SCRATCH, SNAPSHOT, S3
      #snapshotName     = ""  # Specify snapshot here, this is required is type = SNAPSHOT
      #bucket_name     = ""   # This is required is type = S3
      #bucket_prefix   = ""   # This is required is type = S3
    }
    
  }

  # ECR Registries
  ECR = {
    enabled = true
    repository-names = [ 
      var.ecr_repository_api,
      var.ecr_repository_web,
      var.ecr_repository_data_api,
      var.ecr_repository_core_ml,
      "helper",
      "ssr",
    ]
  }

  # S3 Buckets  
  S3 = {
    enabled = false
    bucket-names = ["input-data-bucket", "backups", "argo-artifacts"]
    backup-bucket = "backups"
  }

  # SQS  
  SQS = {
    enabled = false
    queue-names = ["s3-event-notification-queue"]
  }

  # AWS Auth  
  aws-auth = {
    enabled = false
    users = [var.authenticated_user_1,var.authenticated_user_2]
  }
  
   # Bastion Host
  BASTION_HOST = {
    enabled             = false
    name                = "bastion"
    ingress-cidr-blocks = [var.bastion_ingress_cidr_blocks]
    ssh-key             = var.ec2_public_key

    spec =  {
      instance-type = var.bastion_instance_type
      image-ami     = var.bastion_image_ami
      volume-size   = var.bastion_volume_size
      volume-type   = var.bastion_volume_type
      min-size      = var.bastion_min_size
      max-size      = var.bastion_max_size
      desired-size  = var.bastion_size
    }
  }

  # K8S Resources
  K8S = {
    enabled   = true
    namespace = var.project_namespace
    main-sa   = var.main_service_account_name # This service account will give IAM permissions to manage s3 and s3
    db-secret = var.db_secret_name            # Secret to hold all creds to connect to the RDS database

    runner = {
      enabled = true
      token   = var.runner_token
      tag     = var.runner_tag
    }
    
    argo-cd = {
      harbor-username = var.harbor_username
      harbor-password = var.harbor_password
      git-username = var.git_username
      git-password = var.git_password
    }

    alb = {
      enabled   = true
      namespace = "kube-system"
      sa-name   = "alb-sa-iam"
    }

    efs = {
      enabled   = true
      namespace = "kube-system"
      sa-name   = "efs-sa-iam"
      private-subnets = [var.eks_private_subnet_1, var.eks_private_subnet_2]
    }
    
    gp3 = {
      enabled   = true
      namespace = "kube-system"
      sa-name   = "gp3-sa-iam"
    }

    dns = {
      enabled   = true
      namespace = "kube-system"
      sa-name   = "dns-sa-iam"
      domain    = var.domain
    }

  }

  cross-accounts-backup = {
    enabled = false
    target-account-id = var.target_account_id
    target-account-access-key = var.target_account_access_key
    target-account-secret-key = var.target_account_secret_key
    target-account-session-token = var.target_account_session_token
  }
   
  #TLS
  tls-crt = var.tls_crt
  tls-key = var.tls_key

  
}