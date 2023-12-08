<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.61.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.61.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_openvpn_ec2_instance"></a> [openvpn\_ec2\_instance](#module\_openvpn\_ec2\_instance) | terraform-aws-modules/ec2-instance/aws | 3.5.0 |
| <a name="module_ops_key_pair"></a> [ops\_key\_pair](#module\_ops\_key\_pair) | terraform-aws-modules/key-pair/aws | 1.0.1 |
| <a name="module_vpc_peering_staging"></a> [vpc\_peering\_staging](#module\_vpc\_peering\_staging) | cloudposse/vpc-peering/aws | 0.9.2 |
| <a name="module_vpn-vpc"></a> [vpn-vpc](#module\_vpn-vpc) | terraform-aws-modules/vpc/aws | 3.18.0 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.openvpn](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Environment"></a> [Environment](#input\_Environment) | Environemtn name. | `string` | n/a | yes |
| <a name="input_acceptor-vpc-id"></a> [acceptor-vpc-id](#input\_acceptor-vpc-id) | VPC ID to use in the vpc peering with the openvpn vpc | `string` | n/a | yes |
| <a name="input_aws-region"></a> [aws-region](#input\_aws-region) | AWS Region | `string` | n/a | yes |
| <a name="input_azs"></a> [azs](#input\_azs) | The AWS AZ to deploy Openvpn | `list(string)` | n/a | yes |
| <a name="input_cluster-name"></a> [cluster-name](#input\_cluster-name) | EKS Cluster name | `string` | n/a | yes |
| <a name="input_ec2-public-key"></a> [ec2-public-key](#input\_ec2-public-key) | SSH Public key | `string` | n/a | yes |
| <a name="input_private-subnets"></a> [private-subnets](#input\_private-subnets) | Openvpn private subnets | `list(string)` | n/a | yes |
| <a name="input_project-prefix"></a> [project-prefix](#input\_project-prefix) | Project prefix | `string` | n/a | yes |
| <a name="input_public-subnets"></a> [public-subnets](#input\_public-subnets) | Openvpn private subnets | `list(string)` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC CIDR block | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->