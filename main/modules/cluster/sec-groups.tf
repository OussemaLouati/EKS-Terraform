



# Cluster SG
module "cluster-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.0"

  name        = "cluster-sg"
  description = "EKS node security groups"
  vpc_id      = data.aws_vpc.eks.id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allow pods to communicate with the cluster API Server"
      source_security_group_id = module.node-sg.security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Name        = "${var.cluster.cluster-name}-eks-cluster-sg"
    Environment = var.Environment
    CreatedBy   = "Terraform"
  }
}

# Bastion SG
module "cluster-ssh-vpc" {
  count   = var.bastion-enabled ? 1 : 0
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.0"

  name        = "cluster-sg"
  description = "Allow bastion to reach cluster API"
  vpc_id      = data.aws_vpc.eks.id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allow the bastion host to communicate with the cluster API Server"
      source_security_group_id = var.bastion-sec-group-id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Name        = "${var.cluster.cluster-name}-eks-cluster-ssh"
    Environment = var.Environment
    CreatedBy   = "Terraform"
  }
}

# NODES SECURITY GROUPS
module "node-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.0"

  name        = "node-sg"
  description = "EKS node security groups"
  vpc_id      = data.aws_vpc.eks.id

  ingress_cidr_blocks = [data.aws_vpc.eks.cidr_block]
  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]
  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 1025
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Allow EKS Control Plane"
      source_security_group_id = module.cluster-sg.security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Name                                                = "${var.cluster.cluster-name}-eks-node-sg"
    "kubernetes.io/cluster/${var.cluster.cluster-name}" = "owned"
    Environment                                         = var.Environment
    CreatedBy                                           = "Terraform"
  }
}

# NORDSDES SECURITY GROUPS
module "rds-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.0"

  count = var.db.enabled ? 1 : 0

  name        = "rds-sg"
  description = "RDS security groups"
  vpc_id      = data.aws_vpc.eks.id

  ingress_cidr_blocks = [data.aws_vpc.eks.cidr_block]

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "Allow traffic on port 5432"
      source_security_group_id = aws_eks_cluster.eks-cluster.vpc_config.0.cluster_security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Name                                                = "${var.cluster.cluster-name}-eks-rds-sg"
    "kubernetes.io/cluster/${var.cluster.cluster-name}" = "owned"
    Environment                                         = var.Environment
    CreatedBy                                           = "Terraform"
  }
}

data "aws_security_group" "cluster" {
  vpc_id = data.aws_vpc.eks.id
  name   = module.cluster-sg.security_group_name
}

data "aws_security_group" "cluster-ssh-vpc" {
  count  = var.bastion-enabled ? 1 : 0
  vpc_id = data.aws_vpc.eks.id
  name   = module.cluster-ssh-vpc.0.security_group_name
}

data "aws_security_group" "node" {
  vpc_id = data.aws_vpc.eks.id
  name   = module.node-sg.security_group_name
}

data "aws_security_group" "rds" {
  count  = var.db.enabled ? 1 : 0
  vpc_id = data.aws_vpc.eks.id
  name   = module.rds-sg.0.security_group_name
}