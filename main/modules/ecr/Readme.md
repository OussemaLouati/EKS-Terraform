# ECR Terraform Module
---
Create ECR repositories.

###  1. <a name='Usage'></a>Usage
---
Have a look at the [examples](examples/) for complete references

```terraform
module "ecr" {
  source           = "./modules/ecr"

  enabled          = true
  repository-names = ["registry-1", "registry-2"]
  project-prefix   = "my-project"
  aws-region       = "us-east-1"
  cluster-name     = "my-cluster"
  Environment      = "Production" 
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
|  aws 	|  > 4.18.0 	|  True	|
|||


###  4. <a name='Modules'></a>Modules
---
No modules. 

###  5. <a name='Inputs'></a>Inputs
---
|  Name 	| Description  	| Type  	| Default | Required |
|---	    |:-:	          |---	    |---	    |---	     |
| project-prefix | Project prefix to be used in naming components   	          | `string`  	    |  `null`       	| no         |
| account-id |   AWS account ID 	          |   `string`	    | `null`       	|     no     |
| Environment |  e.g: Staging/Development/Production 	          |  `string` 	    |  `null`       	|  no        |
| aws-region |   AWS region	          |   `string`	    |   `null`       	|  no        |
| cluster-name |  EKS cluster name 	          | `string`  	    |   `null`     	|     no     |
| enabled |   Enable or disable this module	          | `bool`  	    |   `true`     	|  no        |
| repository-names |   List of ECR repositories to create	          | `list(string)`  	    |   `[]`     	|  no        |
|   	          |   	    |        	|          |


###  6. <a name='Outputs'></a>Outputs
---

|  Name 	           | Description  	| 
|---	               |:-:	          |	    
 N/A                   | N/A
  

###  7. <a name='Resources'></a>Resources
---

|   Name	|   Type    	| 	
|---	    |:-:	      |
|   [aws_ecr_repository.repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)	| resource |
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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.repository](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/ecr_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Environment"></a> [Environment](#input\_Environment) | Environment name. | `string` | n/a | yes |
| <a name="input_aws-region"></a> [aws-region](#input\_aws-region) | AWS Region. | `string` | n/a | yes |
| <a name="input_cluster-name"></a> [cluster-name](#input\_cluster-name) | EKS Cluster name | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable/disable the whole module | `string` | n/a | yes |
| <a name="input_project-prefix"></a> [project-prefix](#input\_project-prefix) | Project prefix | `string` | n/a | yes |
| <a name="input_repository-names"></a> [repository-names](#input\_repository-names) | ECR repositories to create | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->