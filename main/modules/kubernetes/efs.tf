#########
data "aws_iam_policy_document" "efs-document" {
  count = var.efs-enabled ? 1 : 0
  statement {
    sid    = "efsDescribe"
    effect = "Allow"

    actions = [ "elasticfilesystem:DescribeAccessPoints",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeMountTargets",
        "ec2:DescribeAvailabilityZones"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "efsCreateAccessPoint"
    effect = "Allow"
    actions = ["elasticfilesystem:CreateAccessPoint"]
    resources = [
      "*"
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
  
  statement {
    sid    = "efsTagAccessPoint"
    effect = "Allow"
    actions = ["elasticfilesystem:TagResource"]
    resources = [
      "*"
    ]
    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }


  statement {
    sid    = "efsDeleteAccessPoint"
    effect = "Allow"
    actions = ["elasticfilesystem:DeleteAccessPoint"]
    resources = [
      "*"
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

}

resource "aws_iam_policy" "efs-policy" {
  count       = var.efs-enabled ? 1 : 0
  name        = "efs-policy"
  description = "EFS policy"

  policy = data.aws_iam_policy_document.efs-document.0.json
}


resource "aws_iam_role" "efs-role" {
  count              = var.efs-enabled ? 1 : 0
  name               = "efs-role"
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
          "${replace(var.cluster-oidc-issuer, "https://", "")}:sub": "system:serviceaccount:${var.efs-namespace}:${var.efs-service-account-name}"
        }
      }
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "efs-role-policy-attachement" {
  count      = var.efs-enabled ? 1 : 0
  policy_arn = "arn:aws:iam::${var.account-id}:policy/${aws_iam_policy.efs-policy.0.name}"
  role       = aws_iam_role.efs-role.0.name
}


################ SA #################
resource "kubernetes_service_account" "efs-service-account" {
  count = var.efs-enabled ? 1 : 0
  metadata {
    name      = var.efs-service-account-name
    namespace = var.efs-namespace
    annotations = {
      "eks.amazonaws.com/role-arn" : "arn:aws:iam::${var.account-id}:role/${aws_iam_role.efs-role.0.name}"
    }
  }
}


# resource "kubernetes_secret" "efs-secret-token" {
#   count = var.efs-enabled ? 1 : 0
#   metadata {
#     name      = "${var.efs-service-account-name}-token"
#     namespace = var.efs-namespace
#     annotations = {
#       "kubernetes.io/service-account.name" = var.efs-service-account-name
#     }
#   }

#   type = "kubernetes.io/service-account-token"
# }

resource "helm_release" "efs-release" {
  count            = var.efs-enabled ? 1 : 0
  name             = "aws-efs-csi-driver"
  repository       = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart            = "aws-efs-csi-driver"
  namespace        = var.efs-namespace

  values = [<<EOF
    controller:
      serviceAccount: 
        create: false
        name: ${var.efs-service-account-name}
    image:
      repository: 602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/aws-efs-csi-driver
  EOF
  ]
}

resource "aws_efs_file_system" "efs" {
  count            = var.efs-enabled ? 1 : 0
  performance_mode = "generalPurpose"

}

resource "aws_efs_mount_target" "efs" {
  count = var.efs-enabled ? 2 : 0
  file_system_id = aws_efs_file_system.efs.0.id
  subnet_id      = var.private-subnet-ids[count.index]
  security_groups =  [ data.aws_security_group.efs.0.id ]
}

resource "kubernetes_storage_class" "example" {
  count            = var.efs-enabled ? 1 : 0
  metadata {
    name = "efs-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  
  storage_provisioner = "efs.csi.aws.com"
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId = aws_efs_file_system.efs.0.id
    directoryPerms= "700"
  }
}

resource "kubernetes_annotations" "default-storageclass" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  force       = "true"

  metadata {
    name = "gp2"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }
}

resource "aws_security_group" "efs_sg" {
  count            = var.efs-enabled ? 1 : 0
  name        = "efs-sg"
  description = "SG to allow to reach the filesystem"
  vpc_id      = var.vpc-id

  ingress {
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.eks.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name                                                = "${var.cluster-name}-efs-sg"
    Environment                                         = var.Environment
    CreatedBy                                           = "Terraform"
  }
}

data "aws_vpc" "eks" {
  id = var.vpc-id
}


data "aws_security_group" "efs" {
  count  = var.efs-enabled? 1 : 0
  vpc_id = var.vpc-id
  name   = aws_security_group.efs_sg.0.name
}

