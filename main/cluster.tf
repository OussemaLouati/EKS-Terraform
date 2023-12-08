module "eks-cluster" {
  source = "./modules/cluster"

  # Global config
  project-prefix = var.project-prefix ###
  project-name   = var.project-name   ###
  account-id     = var.account-id     ###
  Environment    = var.Environment    ###

  # EKS cluster
  cluster = var.EKS

  # Database config
  db = var.RDS
  ingestion-role = module.cluster-resources.ingestion-role

  bastion-enabled      = var.BASTION_HOST.enabled
  bastion-sec-group-id = module.bastion.bastion-sec-group-id


}




