data "aws_vpc" "eks" {
  id = var.vpc-id
}


data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }

  tags = {
    Name = "${var.cluster-name}-eks-public"
  }
}

