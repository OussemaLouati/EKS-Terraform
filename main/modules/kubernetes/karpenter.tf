resource "aws_iam_role" "karpenter_controller" {
  count              = var.efs-enabled ? 1 : 0
  name               = "karpenterRole"
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
          "${replace(var.cluster-oidc-issuer, "https://", "")}:sub": "system:serviceaccount:karpenter:karpenter"
        }
      }
    }
  ]
}
POLICY
}


data "aws_iam_policy_document" "karpenter_controller" {
  count = var.efs-enabled ? 1 : 0
  statement {
    sid    = "Karpenter"
    effect = "Allow"

    actions = [ "ssm:GetParameter",
                "iam:PassRole",
                "ec2:RunInstances",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeInstanceTypeOfferings",
                "ec2:DescribeAvailabilityZones",
                "ec2:DeleteLaunchTemplate",
                "ec2:CreateTags",
                "ec2:CreateLaunchTemplate",
                "ec2:CreateFleet",
                "ec2:TerminateInstances",
                "ec2:*",
                "iam:CreateServiceLinkedRole",
                "iam:ListRoles",
                "iam:ListInstanceProfiles",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "ConditionalEC2Termination"
    effect = "Allow"
    actions = ["ec2:TerminateInstances"]
    resources = [
      "*"
    ]
    condition {
      test     = "StringLike"
      variable = "karpenter*"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "karpenter_controller" {
  count       = var.efs-enabled ? 1 : 0
  name        = "karpenterPolicy"
  description = "Karpenter Policy"

  policy = data.aws_iam_policy_document.karpenter_controller.0.json
}



resource "aws_iam_role_policy_attachment" "karpenter_controller" {
  count      = var.efs-enabled ? 1 : 0
  policy_arn = "arn:aws:iam::${var.account-id}:policy/${aws_iam_policy.karpenter_controller.0.name}"
  role       = aws_iam_role.karpenter_controller.0.name
}




resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile"
  role = var.node-role-name
}

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  //version    = "v0.31.0"
  
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.0.arn
  }

  set {
    name  = "clusterName"
    value = var.cluster-name
  }

  set {
    name  = "clusterEndpoint"
    value = var.cluster-endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }

}