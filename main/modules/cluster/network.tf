##############################
#   Network: VPV + Subnet    #
##############################

# VPC

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.0"

  name = "${var.cluster.cluster-name}-eks-vpc"

  cidr = var.cluster.network.vpc

  azs              = var.cluster.network.azs
  private_subnets  = var.cluster.network.private-subnets
  public_subnets   = var.cluster.network.public-subnets
  database_subnets = var.db.enabled ? var.db.subnets : []

  create_database_subnet_group = var.db.enabled

  enable_dns_hostnames = true
  enable_dns_support = true

  enable_nat_gateway = true
  single_nat_gateway = true


  tags = {
    Name                                                = "${var.cluster.cluster-name}-vpc"
    "kubernetes.io/cluster/${var.cluster.cluster-name}" = "shared"
    Environment                                         = var.Environment
    CreatedBy                                           = "Terraform"
  }

  public_subnet_tags = {
    Name                                                = "${var.cluster.cluster-name}-eks-public"
    "kubernetes.io/cluster/${var.cluster.cluster-name}" = "shared"
    "kubernetes.io/role/elb"                            = 1
    Environment                                         = var.Environment
    CreatedBy                                           = "Terraform"
  }
  private_subnet_tags = {
    Name                                                = "${var.cluster.cluster-name}-eks-private"
    "kubernetes.io/cluster/${var.cluster.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"                   = 1
    Environment                                         = var.Environment
    CreatedBy                                           = "Terraform"
  }
  database_subnet_tags = {
    Name        = "${var.cluster.cluster-name}-eks-db"
    Environment = var.Environment
    CreatedBy   = "Terraform"
  }
}

data "aws_vpc" "eks" {
  id = module.vpc.vpc_id
}

data "aws_subnets" "private" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }

  tags = {
    Name = "${var.cluster.cluster-name}-eks-private"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }

  tags = {
    Name = "${var.cluster.cluster-name}-eks-public"
  }
}

data "aws_subnets" "db" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }

  tags = {
    Name = "${var.cluster.cluster-name}-eks-db"
  }
}