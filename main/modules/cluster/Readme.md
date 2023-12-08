# EKS Cluster
---
Create a production grade EKS cluster.

###  1. <a name='Usage'></a>Usage
---
Have a look at the [examples](examples/) for complete references

```terraform
module "cluster" {
  source = "./modules/cluster"

  project-prefix       = "my-project"
  project-name         = "My Project
  account-id           = "123456789123"
  Environment          = "Production"
  cluster              = {
    cluster-name = "my-cluster"
    k8s-version  = "1.22"
    network = {
      region          = "us-east-1"
      azs             = ["us-east-1a", "us-east-1b"]
      vpc             = "10.10.0.0/16"
      private-subnets = ["10.0.0.0/19", "10.0.32.0/19"]
      public-subnets  = ["10.0.128.0/20", "10.0.144.0/20"]
    }
    nodes = [
      {
        instance-type = "c6a.12xlarge"
        min           = 1
        max           = 1
        node-count    = 1
      },
      {
        instance-type = "t3.small"
        min           = 1
        max           = 3
        node-count    = 2
     }
    ]
  }
  db                   = {
    enabled               = true
    db-name               = "my_name"
    engine                = "postgres"
    engine-version        = 14.1
    instance-class        = "db.t3.micro"
    username              = "my_user"
    password              = "my_password"
    allocated-storage     = 
    max-allocated-storage = 100
    subnets               = ["10.0.192.0/21", "10.0.200.0/21"]
    enable-backup         = true
  }
  bastion-enabled      = true
  bastion-sec-group-id = "sg-0f0db94a7ef4587963"
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
|  Name 	| Source  	| Required  	|
|---	|:-:	|---	|
|  VPC 	|  [https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) 	|  True 	|
|||

###  5. <a name='Inputs'></a>Inputs
---
|  Name 	| Description  	| Type  	| Default | Required |
|---	    |:-:	          |---	    |---	    |---	     |
| project-prefix | Project prefix to be used in naming components   	          | `string`  	    |   `null`      	| no         |
| project-name |  Project name to be used in tagging components   	          |   `string`	    |  `null`       	|   no       |
| account-id |   AWS account ID 	          |   `string`	    |  `null`       	|     no     |
| Environment |  e.g: Staging/Development/Production 	          |  `string` 	    |  `null`      	|  no        |
| cluster |   EKS cluster specifications`*`	          |   `any`	    | `{}`        	|  yes        |
| db |  RDS database config`*` 	          |   `map(any)`	    | `{}`         	|      no    |
| bastion-sec-group-id |  Bastion security group id 	          | `string`  	    |   `null`     	|     no     |
| bastion-enabled |   Variable to specify if a bastion host was created or no, this is to configure all necessary security groups, etc.. to be able to access the cluster	          | `bool`  	    |   `false`     	|  no        |
| aws-auth |  Add users to be able to access the cluster`*`	          |  `map(any)` 	    | `{}`       	|   no       |
|   	          |   	    |        	|          |

`*` For more details on how to use and fill these fields, refer to the [Usage](#Usage) section.

###  6. <a name='Outputs'></a>Outputs
---

|  Name 	           | Description  	| 
|---	               |:-:	          |	    
| cluster-endpoint     |  EKS cluster endpoint 	          | 
| cluster-cert-auth |  Cluster CA certificate	          |   
| cluster-oidc-issuer |   	Cluster OIDC issuer          |  
| database-endpoint |  RDS database endpoint 	          |
| vpc-id |  VPC ID 	          |
| node-role-arn | Nodegroups role arn |
|  	|  	    |   



###  7. <a name='Resources'></a>Resources
---

|   Name	|   Type    	| 	
|---	    |:-:	      |
|   [aws_db_instance.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)	| resource |
|   [aws_eks_cluster.eks-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster)	| resource |
|   [aws_eks_node_group.eks-node-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group)	| resource |
|   [aws_iam_instance_profile.node-profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile)	| resource |
|   [aws_iam_role.cluster-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)	| resource |
|   [aws_iam_role.node-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)	| resource | 
|   [aws_iam_role_policy_attachment.Amazon-EKS-VPC-ResourceController](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)	| resource |
|   [aws_iam_role_policy_attachment.amazon-EC2-container-registry-ReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)	| resource |
|   [aws_iam_role_policy_attachment.amazon-EKS-CNI-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)	| resource |
|   [aws_iam_role_policy_attachment.amazon-EKS-cluster-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)	| resource |
|   [aws_iam_role_policy_attachment.amazon-EKS-service-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)	| resource |
|   [aws_iam_role_policy_attachment.amazon-EKS-worker-node-polic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)	| resource |
|   [aws_security_group.this_name_prefix](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)	| resource |
|   [aws_security_group_rule.egress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)	| resource |
|   [aws_security_group_rule.ingress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)	| resource |
|   [aws_db_subnet_group.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)	| resource |
|   [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)	| resource |
|   [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)	| resource |
|   [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)	| resource |
|   [aws_route.private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)	| resource |
|   [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)	| resource |
|   [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)	| resource |
|   [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)	| resource |
|   [aws_route_table_association.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)	| resource |
|   [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)	| resource |
|   [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)	| resource |
|   [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)	| resource |
|   [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)	| resource |
|   [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)	| resource |
|   [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)	| resource |
|   [aws_db_instance.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_instance)	| data source |
|   [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)	| data source |
|   [aws_security_group.cluster-ssh-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)	| data source |
|   [aws_security_group.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)	| data source |
|   [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group)	| data source |
|   [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)	| data source |
|   [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)	| data source |
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
| <a name="provider_aws.replica"></a> [aws.replica](#provider\_aws.replica) | 4.61.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster-sg"></a> [cluster-sg](#module\_cluster-sg) | terraform-aws-modules/security-group/aws | 4.16.0 |
| <a name="module_cluster-ssh-vpc"></a> [cluster-ssh-vpc](#module\_cluster-ssh-vpc) | terraform-aws-modules/security-group/aws | 4.16.0 |
| <a name="module_node-sg"></a> [node-sg](#module\_node-sg) | terraform-aws-modules/security-group/aws | 4.16.0 |
| <a name="module_rds-sg"></a> [rds-sg](#module\_rds-sg) | terraform-aws-modules/security-group/aws | 4.16.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.18.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.postgres](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/db_instance) | resource |
| [aws_db_instance.postgresFromS3](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/db_instance) | resource |
| [aws_db_instance.postgresFromSnapshot](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/db_instance) | resource |
| [aws_db_instance_automated_backups_replication.rds-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/db_instance_automated_backups_replication) | resource |
| [aws_db_instance_automated_backups_replication.rds-backup-s3](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/db_instance_automated_backups_replication) | resource |
| [aws_db_instance_automated_backups_replication.rds-backup-snapshot](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/db_instance_automated_backups_replication) | resource |
| [aws_eks_cluster.eks-cluster](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.eks-node-group](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/eks_node_group) | resource |
| [aws_iam_instance_profile.node-profile](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.cluster-role](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role.node-role](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.Amazon-EKS-VPC-ResourceController](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon-EC2-container-registry-ReadOnly](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon-EKS-CNI-policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon-EKS-cluster-policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon-EKS-service-policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon-EKS-worker-node-policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon-filesystem-access](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_db_instance.postgres](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/db_instance) | data source |
| [aws_db_instance.postgresFromS3](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/db_instance) | data source |
| [aws_db_instance.postgresFromSnapshot](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/db_instance) | data source |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/security_group) | data source |
| [aws_security_group.cluster-ssh-vpc](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/security_group) | data source |
| [aws_security_group.node](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/security_group) | data source |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/security_group) | data source |
| [aws_subnets.db](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/subnets) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/subnets) | data source |
| [aws_vpc.eks](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Environment"></a> [Environment](#input\_Environment) | Environemnt name. | `string` | n/a | yes |
| <a name="input_account-id"></a> [account-id](#input\_account-id) | Account ID | `string` | n/a | yes |
| <a name="input_bastion-enabled"></a> [bastion-enabled](#input\_bastion-enabled) | Variable to specify if bastion host was created or not | `bool` | n/a | yes |
| <a name="input_bastion-sec-group-id"></a> [bastion-sec-group-id](#input\_bastion-sec-group-id) | Bastion security group id if it exists | `string` | n/a | yes |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | EKS Cluster Object config | <pre>object({<br>    cluster-name = string<br>    k8s-version  = string<br><br>    network = object({<br>      region          = string<br>      vpc             = string<br>      azs             = list(string)<br>      private-subnets = list(string)<br>      public-subnets  = list(string)<br>    })<br><br>    nodes = list(object({<br>      instance-type = string<br>      node-count    = number<br>      max           = number<br>      min           = number<br>      taints        = bool<br>    }))<br><br>  })</pre> | n/a | yes |
| <a name="input_db"></a> [db](#input\_db) | RDS config | <pre>object({<br>    enabled               = bool<br>    db-name               = string<br>    engine                = string<br>    engine-version        = string<br>    instance-class        = string<br>    username              = string<br>    password              = string<br>    allocated-storage     = number<br>    max-allocated-storage = number<br>    subnets               = list(string)<br>    backup-enabled        = bool<br>    recoverFrom = object({<br>      snapshotName     = optional(string)<br>      type             = optional(string)<br>      bucket_name      = optional(string)<br>      bucket_prefix    = optional(string)<br>    })<br>    <br>  })</pre> | n/a | yes |
| <a name="input_ingestion-role"></a> [ingestion-role](#input\_ingestion-role) | Role to assume when downloading the snapshot from s3 | `string` | n/a | yes |
| <a name="input_project-name"></a> [project-name](#input\_project-name) | Project Name | `string` | n/a | yes |
| <a name="input_project-prefix"></a> [project-prefix](#input\_project-prefix) | Project prefix | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster-cert-auth"></a> [cluster-cert-auth](#output\_cluster-cert-auth) | Cluster certificate authority |
| <a name="output_cluster-endpoint"></a> [cluster-endpoint](#output\_cluster-endpoint) | Cluster endpoint |
| <a name="output_cluster-oidc-issuer"></a> [cluster-oidc-issuer](#output\_cluster-oidc-issuer) | Cluster oidc issuer |
| <a name="output_database-endpoint"></a> [database-endpoint](#output\_database-endpoint) | Database endpoint |
| <a name="output_db-subnets-ids"></a> [db-subnets-ids](#output\_db-subnets-ids) | Lits of IDs of private subnets of rds database |
| <a name="output_node-role-arn"></a> [node-role-arn](#output\_node-role-arn) | Node group role arn |
| <a name="output_node-role-name"></a> [node-role-name](#output\_node-role-name) | Node role name |
| <a name="output_private-subnet-ids"></a> [private-subnet-ids](#output\_private-subnet-ids) | Lits of IDs of private subnets |
| <a name="output_vpc-id"></a> [vpc-id](#output\_vpc-id) | VPC ID |
<!-- END_TF_DOCS -->