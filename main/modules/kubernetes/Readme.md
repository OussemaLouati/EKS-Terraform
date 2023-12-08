# Kubernetes Terraform module
---
Add custom K8S resources.

###  1. <a name='Usage'></a>Usage
---
Have a look at the [examples](examples/) for complete references.

```terraform
module "resources" {
  source = "./modules/kubernetes"

  project-prefix           = "my-project"
  project-name             = "Deep Project"
  Environment              = "Production"
  account-id               = "12345678910"
  aws-region               = "us-east-1"
  cluster-name             = "my-cluster"
  cluster-cert-auth        = ""
  cluster-endpoint         = ""
  cluster-oidc-issuer      = ""
  vpc-id                   = "vpc-016a0a315289fbf3f"
  enabled                  = true
  project-namespace        = "my-namespace"
  service-account-name     = "my-sa"
  bucket-arns              = ["arn:aws:s3:::some-bucket"]
  queue-arns               = [""]
  runner-token             = ""
  runner-enabled           = true
  runner-tag               = "my-tag"
  dns-enabled              = true
  dns-service-account-name = "my-dns-sa"
  domain                   = "example.com"
  dns-namespace            = "kube-system"
  alb-enabled              = true
  alb-service-account-name = "my-alb-sa"
  alb-namespace            = "kube-system"
  create_aws_auth_configmap = true
  aws-auth-users           = ["user-1", "user-2"]
  node-role-arn            = ""
  db                       = {
                    enabled     = true
                    db-name     = "my-db"
                    secret-name = "my-db-secret"
                    host        = "https://path/to/my-db"
                    username    = "my-username"
                    password    = "my-password"
                }
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
|  kubernetes 	|  2.0 	|  True	|
| helm  	| 2.3.0  	|  False	|
|  kubectl 	| >= 1.7.0  	|  False	|
|  tls 	|  4.0.1 	|  False	|
|||


###  4. <a name='Modules'></a>Modules
---
No modules.

###  5. <a name='Inputs'></a>Inputs
---
|  Name 	| Description  	| Type  	| Default | Required |
|---	    |:-:	          |---	    |---	    |---	     |
| project-prefix | Project prefix to be used in naming components   	          |  `string` 	   |    `null`  	|  no         |
| project-name |  Project name to be used in tagging components   	          |  `string` 	   |    `null`  	|   no       |
| account-id |   AWS account ID 	          |  `string` 	   |    `null`  	|     no     |
| Environment |  e.g: Staging/Development/Production 	          |  `string` 	   |    `null`  	|  no        |
| db |  database config`*` 	          |   `map(any)`	    |  `{}`      	|      no    |
| aws-region |  AWS region	          |  `string` 	   |    `null`  	|  no        |
| cluster-name |  EKS cluster name 	          |  `string` 	   |    `null`  	|  no        |
| cluster-cert-auth |  PEM-encoded root certificates bundle for TLS authentication |  `string` 	   |    `null`  	|  no        |
| cluster-endpoint | The hostname (in form of URI) of the Kubernetes API. |  `string` 	   |    `null`  	|  no        |
| cluster-oidc-issuer |   Issuer URL for the OpenID Connect identity provider  |  `string` 	   |    `null`  	|  no        |
|  vpc-id |  VPC ID	          |  `string` 	   |    `null`  	|  no        |
| enabled |  Enable/disable this whole module 	          |  `bool` 	   |    `false`  	|  no        |
| project-namespace |  Main K8s namespace to create 	          |  `string` 	   |    `null`  	|  no        |
| service-account-name |  Mains service account that will hold permission to access all s3 buckets and sqs queues created 	          |  `string` 	   |    `null`  	|  no        |
| bucket-arns |  List of S3 bucket ARNs 	          |  `list(string)` 	    |    `[]`    	|  no        |
| queue-arns |  List of SQS queues ARNs  	          |  `list(string)` 	    |      `[]`  	|  no        |
| runner-token |  Gitlab runner Token 	          |  `string` 	   |    `null`  	|  no        |
| runner-enabled |  Install a Gitlab runner 	          |  `bool` 	   |    `false`  	|  no        |
| runner-tag |  Gitlab runner tag 	          |  `string` 	   |    `null`  	|  no        |
| dns-enabled |  Enable external DNS, install external DNS controller 	          |  `bool` 	   |    `false`  	|  no        |
| dns-service-account-name |  External DNS service account 	          |  `string` 	   |    `null`  	|  no        |
| domain |  Domain name	          |  `string` 	   |    `null`  	|  no        |
| dns-namespace |  Namespace to install external dns controller in 	          |  `string` 	   |    `null`  	|  no        |
| alb-enabled |  Use Application Load Balancer (ALB) 	          |  `bool` 	   |    `false`  	|  no        |
| alb-service-account-name |  ALB service account 	          |  `string` 	   |    `null`  	|  no        |
| alb-namespace |  Namespace to install ALB controller in 	          |  `string` 	   |    `null`  	|  no        |
| create_aws_auth_configmap |  Enable the creation `"aws-auth"` ConfigMap   |  `bool` 	   |    `false`  	|  no        |
| aws-auth-users |  AWS usernames to be granted access to the cluster 	          |  `list(string)` 	   |    `[]`  	|  no        |
| node-role-arn |  Nodegroup role ARN	          |  `string` 	   |    `null`  	|  no        |
|   	          |   	    |        	|          |

`*` For more details on how to use and fill these fields, refer to the [Usage](#Usage) section.

###  6. <a name='Outputs'></a>Outputs
---

|  Name 	           | Description  	| 
|---	               |:-:	          |	    
 N/A                   | N/A
   

###  7. <a name='Resources'></a>Resources
---

|   Name	|   Type    	| 	
|---	    |:-:	      |
|   [aws_eks_cluster_auth.eks-cluster](aws_eks_cluster_auth)	| data source |
|   [aws_iam_policy_document.alb-document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)	| data source |
|   [aws_iam_policy_document.external-dns-document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)	| data source |
|   [aws_iam_policy_document.s3-and-sqs-policy-document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)	| data source |
|   [aws_route53_zone.hosted-zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone)	| data source |
|   [tls_certificate.tls-cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate)	| data source |
|   [aws_iam_openid_connect_provider.oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider)	| resource |
|   [aws_iam_policy.alb-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)	| resource |
|   [aws_iam_policy.external-dns-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)	| resource |
|   [aws_iam_policy.s3-and-sqs-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)	| resource |
|   [aws_iam_role.alb-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)	| resource |
|   [aws_iam_role.external-dns-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)	| resource |
|   [aws_iam_role.s3-and-sqs-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)	| resource |
|   [aws_iam_role_policy_attachment.alb-role-policy-attachement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)	| resource |
|   [aws_iam_role_policy_attachment.external-dns-role-policy-attachement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)	| resource |
|   [aws_iam_role_policy_attachment.s3-and-sqs-role-policy-attachement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)	| resource |
|   [helm_release.alb-ingress-controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)	| resource |
|   [helm_release.external-dns-controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)	| resource |
|   [helm_release.gitlab-runner](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)	| resource |
|   [kubernetes_cluster_role.gitlab-runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role)	| resource |
|   [kubernetes_cluster_role_binding.gitlab-runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding)	| resource |
|   [kubernetes_namespace.ns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace)	| resource |
|   [kubernetes_secret.database-credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret)	| resource |
|   [kubernetes_service.database-service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service)	| resource |
|   [kubernetes_service_account.alb-service-account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account)	| resource |
|   [kubernetes_service_account.dns-service-account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account)	| resource |
|   [kubernetes_service_account.service-account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account)	| resource |
|   	|   	|   	





















<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.61.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.3.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.20.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.61.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.20.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/efs_mount_target) | resource |
| [aws_iam_instance_profile.karpenter](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_openid_connect_provider.oidc](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.alb-policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.efs-policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external-dns-policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.karpenter_controller](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3-and-sqs-policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.alb-role](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role.efs-role](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role.external-dns-role](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role.gp3-role](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role.karpenter_controller](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role.s3-and-sqs-role](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.alb-role-policy-attachement](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.efs-role-policy-attachement](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.external-dns-role-policy-attachement](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.gp3-role-policy-attachement](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.karpenter_controller](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3-and-sqs-role-policy-attachement](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.aliasRds](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.defaultKmsKeyRds](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/kms_key) | resource |
| [aws_security_group.efs_sg](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/security_group) | resource |
| [helm_release.alb-ingress-controller](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.efs-release](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.external-dns-controller](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.gitlab-runner](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.gp3-release](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/2.3.0/docs/resources/release) | resource |
| [kubernetes_annotations.default-storageclass](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/annotations) | resource |
| [kubernetes_cluster_role.gitlab-runner](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.gitlab-runner](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_config_map.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/config_map) | resource |
| [kubernetes_namespace.ns](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/namespace) | resource |
| [kubernetes_secret.backup-credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/secret) | resource |
| [kubernetes_secret.database-credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/secret) | resource |
| [kubernetes_service.database-service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/service) | resource |
| [kubernetes_service_account.alb-service-account](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/service_account) | resource |
| [kubernetes_service_account.dns-service-account](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/service_account) | resource |
| [kubernetes_service_account.efs-service-account](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/service_account) | resource |
| [kubernetes_service_account.gp3-service-account](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/service_account) | resource |
| [kubernetes_service_account.service-account](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/service_account) | resource |
| [kubernetes_storage_class.example](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/storage_class) | resource |
| [kubernetes_storage_class.gp3-sc](https://registry.terraform.io/providers/hashicorp/kubernetes/2.20.0/docs/resources/storage_class) | resource |
| [aws_eks_cluster_auth.eks-cluster](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.alb-document](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.efs-document](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external-dns-document](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.karpenter_controller](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3-and-sqs-policy-document](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.hosted-zone](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/route53_zone) | data source |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/security_group) | data source |
| [aws_vpc.eks](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/vpc) | data source |
| [tls_certificate.tls-cert](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Environment"></a> [Environment](#input\_Environment) | Environemnt name. | `string` | n/a | yes |
| <a name="input_account-id"></a> [account-id](#input\_account-id) | Account ID | `string` | n/a | yes |
| <a name="input_alb-enabled"></a> [alb-enabled](#input\_alb-enabled) | Enable ALB | `bool` | n/a | yes |
| <a name="input_alb-namespace"></a> [alb-namespace](#input\_alb-namespace) | ALB controller namespace | `string` | n/a | yes |
| <a name="input_alb-service-account-name"></a> [alb-service-account-name](#input\_alb-service-account-name) | ALB SA name | `string` | n/a | yes |
| <a name="input_auth0"></a> [auth0](#input\_auth0) | Auth0 config | <pre>object({<br>    Auth0__domain                     = optional(string)<br>    Auth0__clientId                   = optional(string)<br>    Auth0__clientSecret               = optional(string)<br>    Auth0__audience                   = optional(string)<br>    Auth0__audienceManagement         = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_aws-auth-users"></a> [aws-auth-users](#input\_aws-auth-users) | Users to be granted access to the cluster | `list(string)` | n/a | yes |
| <a name="input_aws-region"></a> [aws-region](#input\_aws-region) | AWS Region | `string` | n/a | yes |
| <a name="input_backup-bucket"></a> [backup-bucket](#input\_backup-bucket) | Bucket to use for backups | `string` | n/a | yes |
| <a name="input_bucket-arns"></a> [bucket-arns](#input\_bucket-arns) | ARN of the S3 buckets associated with the project | `list(string)` | n/a | yes |
| <a name="input_bucket-names"></a> [bucket-names](#input\_bucket-names) | Buckets names created by this terraform script | `list(string)` | n/a | yes |
| <a name="input_cluster-cert-auth"></a> [cluster-cert-auth](#input\_cluster-cert-auth) | Token to subscribe the  gitlab runner | `string` | n/a | yes |
| <a name="input_cluster-endpoint"></a> [cluster-endpoint](#input\_cluster-endpoint) | Token to subscribe the  gitlab runner | `string` | n/a | yes |
| <a name="input_cluster-name"></a> [cluster-name](#input\_cluster-name) | Token to subscribe the  gitlab runner | `string` | n/a | yes |
| <a name="input_cluster-oidc-issuer"></a> [cluster-oidc-issuer](#input\_cluster-oidc-issuer) | Token to subscribe the  gitlab runner | `string` | n/a | yes |
| <a name="input_create_aws_auth_configmap"></a> [create\_aws\_auth\_configmap](#input\_create\_aws\_auth\_configmap) | Create aws auth config map | `bool` | n/a | yes |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | n/a | <pre>object({<br>    adobe = object({<br>      accountId        = optional(string)<br>      clientId        = optional(string)<br>      clientSecret        = optional(string)<br>      orgId        = optional(string)<br>    })<br>    rabbitmq = object({<br>      rabbitmq-password        = optional(string)<br>      rabbitmq-erlang-cookie   = optional(string)<br>    })<br>    pusher = object({<br>      Cluster = optional(string)<br>      Encrypted =  optional(string)<br>      AppId = optional(string)<br>      AppKey = optional(string)<br>      AppSecret = optional(string)<br>      DefaultEventName = optional(string)<br>      DefaultChannelName = optional(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_db"></a> [db](#input\_db) | RDS config | <pre>object({<br>    secret-name = optional(string)<br>    enabled     = optional(bool)<br>    db-name     = optional(string)<br>    host        = optional(string)<br>    username    = optional(string)<br>    password    = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_db-subnets-ids"></a> [db-subnets-ids](#input\_db-subnets-ids) | RDS subnets | `list(string)` | n/a | yes |
| <a name="input_dns-enabled"></a> [dns-enabled](#input\_dns-enabled) | Enable DNS | `bool` | n/a | yes |
| <a name="input_dns-namespace"></a> [dns-namespace](#input\_dns-namespace) | External DNS controller namespace | `string` | n/a | yes |
| <a name="input_dns-service-account-name"></a> [dns-service-account-name](#input\_dns-service-account-name) | External DNS SA | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Registred Domain name | `string` | n/a | yes |
| <a name="input_efs-enabled"></a> [efs-enabled](#input\_efs-enabled) | Enable EFS | `bool` | n/a | yes |
| <a name="input_efs-namespace"></a> [efs-namespace](#input\_efs-namespace) | EFS controller namespace | `string` | n/a | yes |
| <a name="input_efs-service-account-name"></a> [efs-service-account-name](#input\_efs-service-account-name) | EFS SA name | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable/disable module | `bool` | n/a | yes |
| <a name="input_git-password"></a> [git-password](#input\_git-password) | Git private repo password | `string` | n/a | yes |
| <a name="input_git-username"></a> [git-username](#input\_git-username) | Git private repo username | `string` | n/a | yes |
| <a name="input_gp3-enabled"></a> [gp3-enabled](#input\_gp3-enabled) | Enable gp3 | `bool` | n/a | yes |
| <a name="input_gp3-namespace"></a> [gp3-namespace](#input\_gp3-namespace) | gp3 controller namespace | `string` | n/a | yes |
| <a name="input_gp3-service-account-name"></a> [gp3-service-account-name](#input\_gp3-service-account-name) | gp3 SA name | `string` | n/a | yes |
| <a name="input_harbor-password"></a> [harbor-password](#input\_harbor-password) | Helm private repo password | `string` | n/a | yes |
| <a name="input_harbor-username"></a> [harbor-username](#input\_harbor-username) | Helm private repo username | `string` | n/a | yes |
| <a name="input_node-role-arn"></a> [node-role-arn](#input\_node-role-arn) | Nodes ARN | `string` | n/a | yes |
| <a name="input_node-role-name"></a> [node-role-name](#input\_node-role-name) | Node role name | `string` | n/a | yes |
| <a name="input_private-subnet-ids"></a> [private-subnet-ids](#input\_private-subnet-ids) | EKS cluster private subnets ids | `list(string)` | n/a | yes |
| <a name="input_project-name"></a> [project-name](#input\_project-name) | Project Name | `string` | n/a | yes |
| <a name="input_project-namespace"></a> [project-namespace](#input\_project-namespace) | Token to subscribe the  gitlab runner | `string` | n/a | yes |
| <a name="input_project-prefix"></a> [project-prefix](#input\_project-prefix) | Project prefix | `string` | n/a | yes |
| <a name="input_queue-arn"></a> [queue-arn](#input\_queue-arn) | ARN of the SQS queues associated with the project | `string` | n/a | yes |
| <a name="input_runner-enabled"></a> [runner-enabled](#input\_runner-enabled) | Add a gitlab runner | `bool` | n/a | yes |
| <a name="input_runner-tag"></a> [runner-tag](#input\_runner-tag) | Runner tag | `string` | n/a | yes |
| <a name="input_runner-token"></a> [runner-token](#input\_runner-token) | Token to subscribe the  gitlab runner | `string` | n/a | yes |
| <a name="input_service-account-name"></a> [service-account-name](#input\_service-account-name) | Token to subscribe the  gitlab runner | `string` | n/a | yes |
| <a name="input_tls-crt"></a> [tls-crt](#input\_tls-crt) | TLS cert .crt | `string` | n/a | yes |
| <a name="input_tls-key"></a> [tls-key](#input\_tls-key) | TLS cert .key | `string` | n/a | yes |
| <a name="input_vpc-id"></a> [vpc-id](#input\_vpc-id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingestion-role"></a> [ingestion-role](#output\_ingestion-role) | role to assume |
<!-- END_TF_DOCS -->