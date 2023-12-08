data "aws_iam_policy_document" "s3-policy-document-backup" {
  count      = var.crossAccountBackupEnabled ? length(local.bucket_names) : 0
  statement {
    sid    = "GetSourceBucketConfiguration"
    effect = "Allow"

    actions = [ "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:GetBucketAcl",
                "s3:GetReplicationConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectVersionTagging"
                ]

    resources = [
        "arn:aws:s3:::${local.bucket_names[count.index]}-backups",
        "arn:aws:s3:::${local.bucket_names[count.index]}-backups/*"
    ]
  }

  statement {
    sid       = "ReplicateToDestinationBuckets"
    effect    = "Allow"
    actions   = ["s3:List*",
                "s3:*Object",
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ReplicateTags"
                ]
    resources = ["arn:aws:s3:::${local.bucket_names[count.index]}/*"] 
  }

  statement {
    sid    = "PermissionToOverrideBucketOwner"
    effect = "Allow"

    actions = ["s3:ObjectOwnerOverrideToBucketOwner"]

    resources = [
      "arn:aws:s3:::${local.bucket_names[count.index]}/*"
    ]
  }
  
}

resource "aws_iam_policy" "s3-policy-backup" {
  count       = var.crossAccountBackupEnabled ? length(local.bucket_names) : 0
  name_prefix = "S3CrossAccountReplication"
  description = "S3 replication"
  provider = aws.backup
  policy = data.aws_iam_policy_document.s3-policy-document-backup[count.index].json
}


resource "aws_iam_role" "s3-role-backup" {
  provider = aws.backup
  count       = var.crossAccountBackupEnabled ? length(local.bucket_names) : 0
  name_prefix               = "S3CrossAccountReplicationRole"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}



resource "aws_iam_role_policy_attachment" "s3-role-policy-attachement-backup" {
  provider = aws.backup
  count       = var.crossAccountBackupEnabled ? length(local.bucket_names) : 0
  policy_arn = "arn:aws:iam::${var.target-account-id}:policy/${aws_iam_policy.s3-policy-backup[count.index].name}"
  role       = aws_iam_role.s3-role-backup[count.index].name
}
