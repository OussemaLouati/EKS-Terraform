# module "vpn" {
#   source = "./modules/OpenVPN"

#   # Global config
#   project-prefix = var.project-prefix ###
#   Environment   = var.Environment   ###
#   cluster-name = var.cluster-name

#   aws-region      = var.aws-region
#   azs             = var.availability-zones
#   vpc             = var.vpn-vpc-cidr-block
#   private-subnets = var.vpn-private-subnets
#   public-subnets  = var.vpn-public-subnets

#   acceptor-vpc-id = module.eks-cluster.vpc-id
#   ec2-public-key  = var.ec2-public-key


# }



