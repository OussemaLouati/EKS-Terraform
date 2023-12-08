# SQS Terraform Module
---
Create SQS Queues

###  1. <a name='Usage'></a>Usage
---
Have a look at the [examples](examples/) for complete references

```terraform
module "sqs" {
  source         = "./modules/sqs"

  queue-names    = ["queue-1", "queue-2"]
  enabled        = true
  aws-region     = "us-east-1"
  cluster-name   = "my-cluster"
  project-prefix = "my-project"
  Environment    = "Prodcution"

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
| project-prefix | Project prefix to be used in naming components   | `string`  	    |  `null`       	| no         |
| Environment |  e.g: Staging/Development/Production 	          |  `string` 	    |  `null`       	|  no        |
| aws-region |   AWS region	          |   `string`	    |   `null`       	|  no        |
| cluster-name |  EKS cluster name 	          | `string`  	    |   `null`     	|     no     |
| enabled |   Enable or disable this module	          | `bool`  	    |   `true`     	|  no        |
| queue-names |   List of SQS queues to create	          | `list(string)`  	    |   `[]`     	|  no        |
|   	          |   	    |        	|          |


###  6. <a name='Outputs'></a>Outputs
---

|  Name 	           | Description  	| 
|---	               |:-:	          |	      
| sqs-arn  	| List of the ARNs of all created SQS queues by this module  	    |   
|  	|  	    |   

###  7. <a name='Resources'></a>Resources
---

|   Name	|   Type    	| 	
|---	    |:-:	      |
|   [aws_sqs_queue.sqs-queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue)	| resource |
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
| [aws_sqs_queue.sqs-queue](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/sqs_queue) | resource |
| [aws_iam_policy_document.queue](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Environment"></a> [Environment](#input\_Environment) | Environemnt name. | `string` | n/a | yes |
| <a name="input_aws-region"></a> [aws-region](#input\_aws-region) | AWS Region | `string` | n/a | yes |
| <a name="input_bucket-arns"></a> [bucket-arns](#input\_bucket-arns) | ARN of the S3 buckets associated with the project | `list(string)` | n/a | yes |
| <a name="input_cluster-name"></a> [cluster-name](#input\_cluster-name) | EKS Cluster name | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable/disable the whole module | `string` | n/a | yes |
| <a name="input_project-prefix"></a> [project-prefix](#input\_project-prefix) | Project prefix | `string` | n/a | yes |
| <a name="input_queue-names"></a> [queue-names](#input\_queue-names) | SQS queues to create | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sqs-arn"></a> [sqs-arn](#output\_sqs-arn) | SQS queue ARN |
<!-- END_TF_DOCS -->