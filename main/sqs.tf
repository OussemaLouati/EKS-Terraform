module "sqs" {
  source = "./modules/sqs"

  queue-names = var.SQS.queue-names
  enabled     = var.SQS.enabled

  aws-region = var.EKS.network.region

  cluster-name = var.EKS.cluster-name

  project-prefix = var.project-prefix ###
  Environment    = var.Environment    ###

  bucket-arns          = module.s3.bucket-arn
}