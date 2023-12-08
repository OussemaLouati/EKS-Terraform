module "ecr" {
  source = "./modules/ecr"

  enabled = var.ECR.enabled

  ###
  repository-names = var.ECR.repository-names

  # Global config
  project-prefix = var.project-prefix ###
  aws-region     = var.EKS.network.region

  cluster-name = var.EKS.cluster-name
  Environment  = var.Environment ###
}