# BASTION
module "ssh_sg" {

  count = var.enabled ? 1 : 0

  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.0"

  name        = "ssh-sg"
  description = "Security group which is to allow SSH from Bastion"
  vpc_id      = data.aws_vpc.eks.id

  ingress_cidr_blocks = var.ingress-cidr-blocks
  ingress_rules       = ["ssh-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}


data "aws_security_group" "bastion" {
  count  = var.enabled ? 1 : 0
  vpc_id = data.aws_vpc.eks.id
  name   = module.ssh_sg.0.security_group_name
}