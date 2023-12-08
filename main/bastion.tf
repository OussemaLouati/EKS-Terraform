module "bastion" {
  source = "./modules/bastion"

  enabled = var.BASTION_HOST.enabled

  # Global config
  project-prefix = var.project-prefix ###
  Environment    = var.Environment    ###

  cluster-name = var.EKS.cluster-name
  aws-region   = var.EKS.network.region

  vpc-id = module.eks-cluster.vpc-id


  ec2-public-key      = var.BASTION_HOST.ssh-key
  image-ami           = var.BASTION_HOST.spec.image-ami
  name                = var.BASTION_HOST.name
  ingress-cidr-blocks = var.BASTION_HOST.ingress-cidr-blocks
  instance-type       = var.BASTION_HOST.spec.instance-type
  volume-size         = var.BASTION_HOST.spec.volume-size
  volume-type         = var.BASTION_HOST.spec.volume-type
  min-size            = var.BASTION_HOST.spec.min-size
  max-size            = var.BASTION_HOST.spec.max-size
  desired-size        = var.BASTION_HOST.spec.desired-size

}



