#########
data "aws_iam_policy_document" "alb-document" {
  count = var.alb-enabled ? 1 : 0
  statement {
    sid    = "accessAcm"
    effect = "Allow"

    actions = ["acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "accessEc2"
    effect = "Allow"
    actions = ["ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:DescribeAvailabilityZones",
    "ec2:RevokeSecurityGroupIngress"]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "accessElb"
    effect = "Allow"
    actions = ["elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
    "elasticloadbalancing:SetWebAcl"]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "accessCognitoIdp"
    effect = "Allow"

    actions = ["cognito-idp:DescribeUserPoolClient"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "accesWafRegional"
    effect = "Allow"

    actions = ["waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL"
    ]

    resources = [
      "*",
    ]
  }


  statement {
    sid    = "accessTag"
    effect = "Allow"

    actions = ["tag:GetResources",
      "tag:TagResources"
    ]

    resources = [
      "*",
    ]
  }


  statement {
    sid    = "accessWaf"
    effect = "Allow"

    actions = ["waf:GetWebACL"]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "accessWafV2"
    effect = "Allow"

    actions = ["wafv2:GetWebACL",
      "wafv2:GetWebACLForResource",
      "wafv2:AssociateWebACL",
    "wafv2:DisassociateWebACL"]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "accessIAM"
    effect = "Allow"

    actions = ["iam:CreateServiceLinkedRole",
      "iam:GetServerCertificate",
    "iam:ListServerCertificates"]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "accessShield"
    effect = "Allow"

    actions = ["shield:DescribeProtection",
      "shield:GetSubscriptionState",
      "shield:DeleteProtection",
      "shield:CreateProtection",
      "shield:DescribeSubscription",
    "shield:ListProtections"]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "alb-policy" {
  count       = var.alb-enabled ? 1 : 0
  name        = "alb-policy"
  description = "This IAM policy will allow our ALB Ingress Controller pod to make calls to AWS APIs"

  policy = data.aws_iam_policy_document.alb-document.0.json
}


resource "aws_iam_role" "alb-role" {
  count              = var.alb-enabled ? 1 : 0
  name               = "alb-role"
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
          "${replace(var.cluster-oidc-issuer, "https://", "")}:sub": "system:serviceaccount:${var.alb-namespace}:${var.alb-service-account-name}"
        }
      }
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "alb-role-policy-attachement" {
  count      = var.alb-enabled ? 1 : 0
  policy_arn = "arn:aws:iam::${var.account-id}:policy/${aws_iam_policy.alb-policy.0.name}"
  role       = aws_iam_role.alb-role.0.name
}


################ SA #################
resource "kubernetes_service_account" "alb-service-account" {
  count = var.alb-enabled ? 1 : 0
  metadata {
    name      = var.alb-service-account-name
    namespace = var.alb-namespace
    annotations = {
      "eks.amazonaws.com/role-arn" : "arn:aws:iam::${var.account-id}:role/${aws_iam_role.alb-role.0.name}"
    }
  }
}

# resource "kubernetes_secret" "alb-secret-token" {
#   count = var.alb-enabled ? 1 : 0
#   metadata {
#     name      = "${var.alb-service-account-name}-token"
#     namespace = var.alb-namespace
#     annotations = {
#       "kubernetes.io/service-account.name" = var.alb-service-account-name
#     }
#   }

#   type = "kubernetes.io/service-account-token"
# }