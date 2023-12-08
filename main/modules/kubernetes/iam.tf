#########
data "aws_iam_policy_document" "s3-and-sqs-policy-document" {
  count = var.enabled ? 1 : 0
  statement {
    sid    = "accessBuckets"
    effect = "Allow"

    actions = ["s3:*"]

    resources = concat(
      sort(var.bucket-arns),
      sort(formatlist("%s/*", var.bucket-arns)),
    )
  }

  statement {
    sid       = "accessQueues"
    effect    = "Allow"
    actions   = ["sqs:*"]
    resources = [var.queue-arn]
  }

  statement {
    sid       = "accessKMS"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"] # var.queue-arns
  }

  
  statement {
    sid    = "accessRDS"
    effect = "Allow"

    actions = ["rds:*"]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "passRole"
    effect = "Allow"

    actions = [
                "iam:GetRole",
                "iam:PassRole"
            ]

    resources = [
      "arn:aws:iam::${var.account-id}:role/${aws_iam_role.s3-and-sqs-role.0.name}",
    ]
  }
}

resource "aws_iam_policy" "s3-and-sqs-policy" {
  count       = var.enabled ? 1 : 0
  name        = "s3-and-sqs-policy"
  description = "Policy to add to EKS pods to be able to connect to SQS and S3"

  policy = data.aws_iam_policy_document.s3-and-sqs-policy-document.0.json
}


resource "aws_iam_role" "s3-and-sqs-role" {
  count              = var.enabled ? 1 : 0
  name               = "s3-and-sqs-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.account-id}:oidc-provider/${replace(var.cluster-oidc-issuer, "https://", "")}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(var.cluster-oidc-issuer, "https://", "")}:aud": "sts.amazonaws.com",
          "${replace(var.cluster-oidc-issuer, "https://", "")}:sub": "system:serviceaccount:${var.project-namespace}:${var.service-account-name}"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
          "Service": "export.rds.amazonaws.com"
        },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "s3-and-sqs-role-policy-attachement" {
  count      = var.enabled ? 1 : 0
  policy_arn = "arn:aws:iam::${var.account-id}:policy/${aws_iam_policy.s3-and-sqs-policy.0.name}"
  role       = aws_iam_role.s3-and-sqs-role.0.name
}

################ SA #################
resource "kubernetes_service_account" "service-account" {
  count = var.enabled ? 1 : 0
  metadata {
    name      = var.service-account-name
    namespace = var.project-namespace
    annotations = {
      "eks.amazonaws.com/role-arn" : "arn:aws:iam::${var.account-id}:role/${aws_iam_role.s3-and-sqs-role.0.name}"
    }
  }
}


resource "kubernetes_secret" "backup-credentials" {
  count = var.db.enabled ? 1 : 0
  metadata {
    name      = "backup-credentials"
    namespace = var.project-namespace
  }

  data = {
    kms_key       = aws_kms_key.defaultKmsKeyRds.arn
    buckup_bucket = "${var.backup-bucket}-${var.Environment}"
    snapshot_id   = "${var.db.db-name}-${var.Environment}"
    buckets_created   = jsonencode(var.bucket-names)
  }
}

resource "aws_kms_key" "defaultKmsKeyRds" {
  description         = "Key to encrypt RDS automated snapshots [${var.cluster-name}]"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.kms.json
  tags                = {
    Environment = var.Environment
    CreatedBy   = "Terraform"
    Name        = var.cluster-name
  }
}

resource "aws_kms_alias" "aliasRds" {
  name          = "alias/kms-Rds-backups-${var.cluster-name}"
  target_key_id = aws_kms_key.defaultKmsKeyRds.key_id
}


data "aws_iam_policy_document" "kms" {
  statement {
    sid     = "Enable IAM User Permissions"
    actions = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account-id}:root"]
    }
    resources = ["*"]
  }

  statement {
    sid = "Allow access for Key Administrators"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account-id}:root"] 
    }
    resources = ["*"]
  }

  # statement {
  #   sid = "Allow use of the key"
  #   actions = [
  #     "kms:Encrypt",
  #     "kms:Decrypt",
  #     "kms:ReEncrypt*",
  #     "kms:GenerateDataKey*",
  #     "kms:DescribeKey",
  #   ]
  #   principals {
  #     type        = "AWS"
  #     identifiers = [aws_iam_role.lambda.arn]
  #   }
  #   resources = ["*"]
  # }

  # statement {
  #   sid = "Allow attachment of persistent resources"
  #   actions = [
  #     "kms:CreateGrant",
  #     "kms:ListGrants",
  #     "kms:RevokeGrant",
  #   ]
  #   principals {
  #     type        = "AWS"
  #     identifiers = [aws_iam_role.lambda.arn]
  #   }
  #   resources = ["*"]
  #   condition {
  #     test     = "Bool"
  #     variable = "kms:GrantIsForAWSResource"
  #     values   = ["true"]
  #   }
  # }
}
