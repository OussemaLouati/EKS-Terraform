module "cluster-resources" {
  source = "./modules/kubernetes"

  # Global config
  project-prefix = var.project-prefix
  project-name   = var.project-name
  Environment    = var.Environment

  account-id = var.account-id
  aws-region = var.EKS.network.region

  cluster-name        = var.EKS.cluster-name
  cluster-cert-auth   = module.eks-cluster.cluster-cert-auth
  cluster-endpoint    = module.eks-cluster.cluster-endpoint
  cluster-oidc-issuer = module.eks-cluster.cluster-oidc-issuer
  node-role-name      = module.eks-cluster.node-role-name
  vpc-id = module.eks-cluster.vpc-id

  # Main sa and permissions to manage S3 and SQS
  enabled              = var.K8S.enabled
  project-namespace    = var.K8S.namespace
  service-account-name = var.K8S.main-sa
  bucket-arns          = module.s3.bucket-arn
  queue-arn           = module.sqs.sqs-arn
  ## Runner
  runner-token   = var.K8S.runner.token
  runner-enabled = var.K8S.runner.enabled
  runner-tag     = var.K8S.runner.tag

  # DNS
  dns-enabled              = var.K8S.dns.enabled
  dns-service-account-name = var.K8S.dns.sa-name
  domain                   = var.K8S.dns.domain
  dns-namespace            = var.K8S.dns.namespace

  # ALB
  alb-enabled              = var.K8S.alb.enabled
  alb-service-account-name = var.K8S.alb.sa-name
  alb-namespace            = var.K8S.alb.namespace

  # EFS
  efs-enabled              = var.K8S.efs.enabled
  efs-service-account-name = var.K8S.efs.sa-name
  efs-namespace            = var.K8S.efs.namespace
  private-subnet-ids       = module.eks-cluster.private-subnet-ids
  
  # GP3
  gp3-enabled              = var.K8S.gp3.enabled
  gp3-service-account-name = var.K8S.gp3.sa-name
  gp3-namespace            = var.K8S.gp3.namespace

  # Database Creds
  db = {
    enabled     = var.RDS.enabled
    db-name     = var.RDS.db-name
    secret-name = var.K8S.db-secret
    host        = module.eks-cluster.database-endpoint
    username    = var.RDS.username
    password    = var.RDS.password
  }

  backup-bucket = var.S3.backup-bucket
  bucket-names = module.s3.bucket-names
  
  #TLS
  tls-crt = var.tls-crt
  tls-key = var.tls-key

  #AWS AUTH
  create_aws_auth_configmap = var.aws-auth.enabled
  aws-auth-users            = var.aws-auth.users
  node-role-arn             = module.eks-cluster.node-role-arn
  
  db-subnets-ids = module.eks-cluster.db-subnets-ids
  
  harbor-username = var.K8S.argo-cd.harbor-username
  harbor-password = var.K8S.argo-cd.harbor-password
  git-username = var.K8S.argo-cd.git-username
  git-password = var.K8S.argo-cd.git-password
  
  auth0 = var.auth0
  credentials = var.credentials
}