module "ops_key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "1.0.1"

  key_name   = "ops"
  public_key = var.ec2-public-key
}

module "openvpn_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.5.0"

  name = "OpenVPN"

  ami                    = "ami-0e1415fedc1664f51" // Community edition OpenVPN 2.8.5
  instance_type          = "t2.small"
  key_name               = module.ops_key_pair.key_pair_key_name
  vpc_security_group_ids = [aws_security_group.openvpn.id]
  subnet_id              = module.vpn-vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "ops"
  }
}