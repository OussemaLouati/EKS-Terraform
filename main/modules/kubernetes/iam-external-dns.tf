#########
data "aws_iam_policy_document" "external-dns-document" {
  count = var.dns-enabled ? 1 : 0
  statement {
    sid    = "changeRecordSets"
    effect = "Allow"

    actions = ["route53:ChangeResourceRecordSets"
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }

  statement {
    sid    = "listHostedZones"
    effect = "Allow"
    actions = ["route53:ListHostedZones",
    "route53:ListResourceRecordSets"]
    resources = [
      "*"
    ]
  }

}

resource "aws_iam_policy" "external-dns-policy" {
  count       = var.dns-enabled ? 1 : 0
  name        = "external-dns-policy"
  description = "This IAM policy will allow our ALB Ingress Controller pod to make calls to AWS APIs"

  policy = data.aws_iam_policy_document.external-dns-document.0.json
}


resource "aws_iam_role" "external-dns-role" {
  count              = var.dns-enabled ? 1 : 0
  name               = "external-dns-role"
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
          "${replace(var.cluster-oidc-issuer, "https://", "")}:sub": "system:serviceaccount:${var.dns-namespace}:${var.dns-service-account-name}"
        }
      }
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "external-dns-role-policy-attachement" {
  count      = var.dns-enabled ? 1 : 0
  policy_arn = "arn:aws:iam::${var.account-id}:policy/${aws_iam_policy.external-dns-policy.0.name}"
  role       = aws_iam_role.external-dns-role.0.name
}


################ SA #################
resource "kubernetes_service_account" "dns-service-account" {
  count = var.dns-enabled ? 1 : 0
  metadata {
    name      = var.dns-service-account-name
    namespace = var.dns-namespace
    annotations = {
      "eks.amazonaws.com/role-arn" : "arn:aws:iam::${var.account-id}:role/${aws_iam_role.external-dns-role.0.name}"
    }
  }
}

# resource "kubernetes_secret" "dns-secret-token" {
#   count = var.dns-enabled ? 1 : 0
#   metadata {
#     name      = "${var.dns-service-account-name}-token"
#     namespace = var.dns-namespace
#     annotations = {
#       "kubernetes.io/service-account.name" = var.dns-service-account-name
#     }
#   }

#   type = "kubernetes.io/service-account-token"
# }

data "aws_route53_zone" "hosted-zone" {
  count        = var.dns-enabled ? 1 : 0
  name         = var.domain
  private_zone = false
}