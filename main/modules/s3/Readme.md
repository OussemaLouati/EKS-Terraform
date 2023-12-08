# S3 Terraform Module
---
Create S3 buckets

###  1. <a name='Usage'></a>Usage
---
Have a look at the [examples](examples/) for complete references

```terraform
module "s3" {
  source         = "./modules/s3"

  enabled        = true
  bucket-names   = ["bucket-1", "bucket-2"]
  project-prefix = "my-project" 
  account-id     = "var.account-id "    
  Environment    = "Production"    
  aws-region     = "us-east-1"
  cluster-name   = "my-cluster"

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
| account-id |   AWS account ID 	          |   `string`	    |   `null`      	|     no     |
| Environment |  e.g: Staging/Development/Production 	          |  `string` 	    |  `null`       	|  no        |
| aws-region |   AWS region	          |   `string`	    |   `null`       	|  no        |
| cluster-name |  EKS cluster name 	          | `string`  	    |   `null`     	|     no     |
| enabled |   Enable or disable this module	          | `bool`  	    |   `true`     	|  no        |
| bucket-names |   List of S3 buckets to create	          | `list(string)`  	    |   `[]`     	|  no        |
|   	          |   	    |        	|          |



###  6. <a name='Outputs'></a>Outputs
---

|  Name 	           | Description  	| 
|---	               |:-:	          |	         
| bucket-arn 	| List of the ARNs of all created S3 bucket by this module 	    |   
|  	|  	    |   


###  7. <a name='Resources'></a>Resources
---

|   Name	|   Type    	| 	
|---	    |:-:	      |
|   [aws_s3_bucket.s3-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)	| resource |
|   [aws_s3_bucket_acl.s3-bucket-acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl)	| resource |
|   [aws_s3_bucket_metric.s3-bucket-metric](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric)	| resource |
|   [aws_s3_bucket_public_access_block.s3-bucket-public-block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)	| resource |
|   [aws_s3_bucket_server_side_encryption_configuration.s3-encrypt-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration)	| resource |
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
| <a name="provider_aws.backup"></a> [aws.backup](#provider\_aws.backup) | 4.61.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.s3-policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3-policy-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.s3-role](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role.s3-role-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.s3-and-sqs-role-policy-attachement](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3-role-policy-attachement-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.s3-bucket](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3-bucket-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.s3-bucket-backup-acl-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_metric.s3-bucket-backup-metric-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_metric) | resource |
| [aws_s3_bucket_metric.s3-bucket-metric](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_metric) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.allow_access_from_another_account](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.allow_access_from_another_account-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.s3-bucket-backup-public-block-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.s3-bucket-public-block](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.replication-source](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_replication_configuration.replication-source-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3-encrypt-config](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3-encrypt-config-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.destination](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.destination-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.allow_access_from_another_account](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_access_from_another_account-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3-policy-document](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3-policy-document-backup](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Environment"></a> [Environment](#input\_Environment) | Environemnt name. | `string` | n/a | yes |
| <a name="input_account-id"></a> [account-id](#input\_account-id) | Account ID | `string` | n/a | yes |
| <a name="input_aws-region"></a> [aws-region](#input\_aws-region) | AWS Region | `string` | n/a | yes |
| <a name="input_bucket-names"></a> [bucket-names](#input\_bucket-names) | S3 buckets to create | `list(string)` | n/a | yes |
| <a name="input_cluster-name"></a> [cluster-name](#input\_cluster-name) | EKS Cluster name | `string` | n/a | yes |
| <a name="input_crossAccountBackupEnabled"></a> [crossAccountBackupEnabled](#input\_crossAccountBackupEnabled) | Enable/disable cross account replication | `bool` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable/disable the whole module | `string` | n/a | yes |
| <a name="input_project-prefix"></a> [project-prefix](#input\_project-prefix) | Project prefix | `string` | n/a | yes |
| <a name="input_queue-arn"></a> [queue-arn](#input\_queue-arn) | ARN of the SQS queues associated with the project | `string` | n/a | yes |
| <a name="input_target-account-access-key"></a> [target-account-access-key](#input\_target-account-access-key) | target account acceess key | `string` | n/a | yes |
| <a name="input_target-account-id"></a> [target-account-id](#input\_target-account-id) | Target account id | `string` | n/a | yes |
| <a name="input_target-account-secret-key"></a> [target-account-secret-key](#input\_target-account-secret-key) | target account secret key | `string` | n/a | yes |
| <a name="input_target-account-session-token"></a> [target-account-session-token](#input\_target-account-session-token) | target account session token | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket-arn"></a> [bucket-arn](#output\_bucket-arn) | S3 bucket ARN |
| <a name="output_bucket-names"></a> [bucket-names](#output\_bucket-names) | S3 bucket names |
<!-- END_TF_DOCS -->