########
#  S3  #
########


resource "aws_s3_bucket" "s3-bucket" {
  count  = var.enabled ? length(var.bucket-names) : 0
  bucket = "${var.bucket-names[count.index]}-${var.Environment}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "${var.cluster-name}-${var.bucket-names[count.index]}-bucket"
    Environment = var.Environment
    CreatedBy   = "Terraform"
  }
}

# resource "aws_s3_bucket_acl" "s3-bucket-acl" {
#   count  = var.enabled ? length(var.bucket-names) : 0
#   bucket = aws_s3_bucket.s3-bucket[count.index].id
#   acl    = "private"
# }

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-encrypt-config" {
  count  = var.enabled ? length(var.bucket-names) : 0
  bucket = aws_s3_bucket.s3-bucket[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "s3-bucket-public-block" {
  count  = var.enabled ? length(var.bucket-names) : 0
  bucket = aws_s3_bucket.s3-bucket[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_metric" "s3-bucket-metric" {
  count  = var.enabled ? length(var.bucket-names) : 0
  bucket = aws_s3_bucket.s3-bucket[count.index].bucket
  name   = "EntireBucket"
}

locals {
  bucket_arns = aws_s3_bucket.s3-bucket.*.arn
  bucket_names = aws_s3_bucket.s3-bucket.*.id
}

resource "aws_s3_bucket_versioning" "destination" {
  count  = var.crossAccountBackupEnabled ? length(var.bucket-names) : 0
  bucket = aws_s3_bucket.s3-bucket[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  count  = var.crossAccountBackupEnabled ? length(local.bucket_names) : 0
  bucket = local.bucket_names[count.index]
  policy = data.aws_iam_policy_document.allow_access_from_another_account[count.index].json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  count  = var.crossAccountBackupEnabled ? length(local.bucket_names) : 0
  statement {
    sid    = "Permissions on objects and buckets"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.s3-role-backup[count.index].arn]
    }

    actions = [
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:ReplicateDelete",
      "s3:ReplicateObject"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_names[count.index]}",
      "arn:aws:s3:::${local.bucket_names[count.index]}/*"
    ]
  }

  statement {
    sid    = "Permission to override bucket owner"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.target-account-id}:root"]
    }

    actions = ["s3:ObjectOwnerOverrideToBucketOwner"]

    resources = [
      "arn:aws:s3:::${local.bucket_names[count.index]}/*"
    ]
  }
}



resource "aws_s3_bucket_replication_configuration" "replication-source" {
  count  = var.crossAccountBackupEnabled ? length(local.bucket_names) : 0
  depends_on = [aws_s3_bucket_versioning.destination, aws_s3_bucket_versioning.destination-backup]

  role   = aws_iam_role.s3-role[count.index].arn
  bucket = local.bucket_names[count.index]

  rule {
    #id = "replicateDataCrossAccounts"
    
    # existing_object_replication {
    #  status = "Enabled"
    # }

    status = "Enabled"
    

    destination {
      bucket = "arn:aws:s3:::${local.bucket_names[count.index]}-backups"

      account = var.target-account-id
      access_control_translation {
       owner = "Destination"
    }
    }
  }
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3-bucket.0.id

  queue {
    queue_arn     = var.queue-arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "input-preprocess/"
  }

}
