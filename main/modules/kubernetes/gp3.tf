resource "aws_iam_role" "gp3-role" {
  count              = var.gp3-enabled ? 1 : 0
  name               = "gp3-role"
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
          "${replace(var.cluster-oidc-issuer, "https://", "")}:sub": "system:serviceaccount:${var.gp3-namespace}:${var.gp3-service-account-name}"
        }
      }
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "gp3-role-policy-attachement" {
  count      = var.gp3-enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.gp3-role.0.name
}


################ SA #################
resource "kubernetes_service_account" "gp3-service-account" {
  count = var.gp3-enabled ? 1 : 0
  metadata {
    name      = var.gp3-service-account-name
    namespace = var.gp3-namespace
    annotations = {
      "eks.amazonaws.com/role-arn" : "arn:aws:iam::${var.account-id}:role/${aws_iam_role.gp3-role.0.name}"
    }
  }
}


resource "helm_release" "gp3-release" {
  count            = var.gp3-enabled ? 1 : 0
  name             = "aws-ebs-csi-driver"
  repository       = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver" 
  chart            = "aws-ebs-csi-driver"
  namespace        = var.gp3-namespace

  values = [<<EOF
    controller:
      serviceAccount: 
        create: false
        name: ${var.gp3-service-account-name}
  EOF
  ]
}


resource "kubernetes_storage_class" "gp3-sc" {
  count            = var.gp3-enabled ? 1 : 0
  metadata {
    name = "ebs-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }
  
  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    type = "gp3"
  }
}




