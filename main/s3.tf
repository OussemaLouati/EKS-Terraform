module "s3" {
  source = "./modules/s3"

  enabled = var.S3.enabled

  ###
  bucket-names = var.S3.bucket-names

  # Global config
  project-prefix = var.project-prefix ###
  account-id     = var.account-id     ###
  Environment    = var.Environment    ###
  aws-region     = var.EKS.network.region
 
  cluster-name = var.EKS.cluster-name
  
  crossAccountBackupEnabled     = var.cross-accounts-backup.enabled
  target-account-id             = var.cross-accounts-backup.target-account-id 
  target-account-access-key      = var.cross-accounts-backup.target-account-access-key
  target-account-secret-key    = var.cross-accounts-backup.target-account-secret-key
  target-account-session-token    = var.cross-accounts-backup.target-account-session-token
  
  queue-arn  = module.sqs.sqs-arn
}