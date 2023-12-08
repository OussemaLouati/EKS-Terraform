# Bastion Terraform module
---
This module can be used to deploy a Bastion host to be used to connect to the EKS cluster from. 

###  1. <a name='Usage'></a>Usage
---
Have a look at the [examples](examples/) for complete references

```terraform
module "bastion" {
  source = "./modules/bastion"

  enabled             = true
  project-prefix      = "my-project"
  Environment         = "Production"  
  cluster-name        = "my_cluster"
  aws-region          = "us-east-1"
  vpc-id              = "vpc-05892000a93c618e8"
  ec2-public-key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDuMrTqpky5TIL8ltjL47T7SGxamJ8+5JmwUqYt+z5GbF3+WgcHWOCATlslF3FhvMOnUGFfxJrWI5FAo51r7T5m/mpGYPG431SREDkwgx3kLLvqD6sv1OOqmJbW1+/dMoKab2kqKRyds1QETARjHqk1HTE1cv9gLqpqUqLlYKXDgPZHQtjNmlO2asBZgC5w4Q4tvWWHrNMkiT8LT64V0gA39BzXXnWFSsBuEMwr8oRGhBDxPYG760NAj6SyOIFUaW10ZCDJlWhR76u/K6ULPYn2jKpDeoawZkeLg6B3vjct9Fy13R9EOKdYtWUN9f8k8vz4vb4kkb3jiNcsPzNndEIg60BfNd4RZMq72pca3CNfXUIAZlHZqrrkLXDCTrfz7w+EkSjPfONmE2lY5n8wIufBTB0rUc5qEssvrWmOToXBNlsxAICvHBckPzR9AoBYn4bJr1ki8NrhsHl1xdo9+YZvAR94CQ3qN0sqkVmYABEk2fJFyS0fc7bSRr4CcQSeE= example@example.com"
  image-ami           = "ami-0b5eea76982371e91"
  name                = "bastion"
  ingress-cidr-blocks = ["0.0.0.0/0"]
  instance-type       = "t2.small"
  volume-size         = 10
  volume-type         = "gp2"
  min-size            = 1
  max-size            = 2
  desired-size        = 1
}
```
###  2. <a name='Requirements'></a>Requirements
---

|   Name	|   Version	| 	
|---	    |:-:	      |
|   Terraform	| >= 0.13.1 | 
|   	|   	|   	


###  3. <a name='Providers'></a>Providers
---

|  Name 	| Version  	| Required  	|
|---	|:-:	|---	|
|  aws 	|  > 4.18.0 	|  True 	|
|||


###  4. <a name='Modules'></a>Modules
---
This Terraform module makes use of custom `submodules` as shown in this following table.

|  Name 	| Source  	| Required  	|
|---	|:-:	|---	|
|  Security group 	|  [https://registry.terraform.io/security-group/](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest) 	|  Yes 	|
|  Autoscaling 	|  [https://registry.terraform.io/autoscaling/](https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/latest)  	|  Yes	|

|||

###  5. <a name='Inputs'></a>Inputs
---
|  Name 	| Description  	| Type  	| Default | Required |
|---	    |:-:	          |---	    |---	    |---	     |
| project-prefix |   Project prefix to be used in naming components   | `string`  	    |   `null`     	| no         |
| project-name | Project name to be used in tagging components  	          |   `string`	    |   `null`       	|   no       |
| account-id | AWS account ID  	          |   `string`	    |  `null`     	|     no     |
| Environment |  e.g: Staging/Development/Production |  `string` 	    |   `null`       	|  no        |
aws-region |   AWS region	          |   `string`	    |   `null`       	|  no        |
cluster-name |  EKS cluster name 	          | `string`  	    |   `null`     	|     no     |
vpc-id |  ID of a VPC where the bastion host will be deployed    |  `string` 	    |   `null`     	|  no        |
enabled |   Enable or disable this module	          | `bool`  	    |   `true`     	|  no        |
ec2-public-key |   SSH public key        |  `string`  	    |  `null`      	|    no      |
ingress-cidr-blocks |   List of CIDR blocks to be used in the inbound rules of the bastion security group	          |   `list(string)`	    |  `["0.0.0.0/0"]`      	|  no        |
image-ami  | Image AMI   |   `string` |          `ami-0b5eea76982371e91` |  no |
  name   |  Host name  |   `string` |          `bastion` |  no |
  instance-type  | VM instance type   |   `string` |          `t2.small` |  no |
  volume-size   | Volume size    |   `number` |          `10` |  no |
  volume-type   | Volume type   |   `string` |          `gp2` |  no |
  min-size    | Autoscaling minimum count    |   `number` |          `1` |  no |
  max-size     | Autoscaling maximum size   |   `number` |          `2` |  no |
  desired-size   | Autoscaling desired size   |   `number` |          `1` |  no |
  |   	          |   	    |        	|          |
###  6. <a name='Outputs'></a>Outputs
---

|  Name 	           | Description  	| 
|---	               |:-:	          |	    
| bastion-sec-group-id  	| Bastion security group id  	    |       
|  	|  	    |   

###  7. <a name='Resources'></a>Resources
---

|   Name	|   Type    	| 	
|---	    |:-:	      |
|   [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)	| data source | 
|   [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)	| data source |
|   [aws_vpc.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)	| data source |
|   [aws_key_pair.key-pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)	| resource |
|   [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)	| resource |
|   [aws_launch_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration)	| resource |
|   [random_pet.asg_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)	| resource |
|   [aws_security_group.this_name_prefix](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)	| resource |
|   [aws_security_group_rule.egress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)	| resource |
|   [aws_security_group_rule.ingress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)	| resource |
|   	|   	|   	





















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
| <a name="module_bastion-asg"></a> [bastion-asg](#module\_bastion-asg) | terraform-aws-modules/autoscaling/aws | ~> 3.0 |
| <a name="module_ssh_sg"></a> [ssh\_sg](#module\_ssh\_sg) | terraform-aws-modules/security-group/aws | 4.16.0 |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.key-pair](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/key_pair) | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/security_group) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/subnets) | data source |
| [aws_vpc.eks](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Environment"></a> [Environment](#input\_Environment) | Environemnt name. | `string` | n/a | yes |
| <a name="input_aws-region"></a> [aws-region](#input\_aws-region) | AWS Region | `string` | n/a | yes |
| <a name="input_cluster-name"></a> [cluster-name](#input\_cluster-name) | EKS Cluster name | `string` | n/a | yes |
| <a name="input_desired-size"></a> [desired-size](#input\_desired-size) | Min size | `string` | n/a | yes |
| <a name="input_ec2-public-key"></a> [ec2-public-key](#input\_ec2-public-key) | SSH Public key | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable/disable the module | `bool` | n/a | yes |
| <a name="input_image-ami"></a> [image-ami](#input\_image-ami) | Image AMI  to be used for the autoscaling group for the bastion host | `string` | n/a | yes |
| <a name="input_ingress-cidr-blocks"></a> [ingress-cidr-blocks](#input\_ingress-cidr-blocks) | Security groups inbound rules | `list(string)` | n/a | yes |
| <a name="input_instance-type"></a> [instance-type](#input\_instance-type) | Ec2 instance type | `string` | n/a | yes |
| <a name="input_max-size"></a> [max-size](#input\_max-size) | Autoscaling group max size | `string` | n/a | yes |
| <a name="input_min-size"></a> [min-size](#input\_min-size) | Autoscaling group Min size | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Bastion host name | `string` | n/a | yes |
| <a name="input_project-prefix"></a> [project-prefix](#input\_project-prefix) | Project prefix | `string` | n/a | yes |
| <a name="input_volume-size"></a> [volume-size](#input\_volume-size) | Volume size | `string` | n/a | yes |
| <a name="input_volume-type"></a> [volume-type](#input\_volume-type) | Volume type | `string` | n/a | yes |
| <a name="input_vpc-id"></a> [vpc-id](#input\_vpc-id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion-sec-group-id"></a> [bastion-sec-group-id](#output\_bastion-sec-group-id) | Bastion security group id |
<!-- END_TF_DOCS -->