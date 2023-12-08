module "vpn-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.0"

  name = "${var.cluster-name}-vpn-vpc"

  cidr = var.vpc

  azs             = var.azs
  private_subnets = var.private-subnets
  public_subnets  = var.public-subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}


module "vpc_peering_staging" {
  source  = "cloudposse/vpc-peering/aws"
  version = "0.9.2"

  name             = "${var.cluster-name}-openvpn-eks-vpc-peering"
  requestor_vpc_id = module.vpn-vpc.vpc_id
  acceptor_vpc_id  = var.acceptor-vpc-id
}
