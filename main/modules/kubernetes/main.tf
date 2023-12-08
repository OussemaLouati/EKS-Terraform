resource "kubernetes_namespace" "ns" {
  count = var.enabled ? 1 : 0
  metadata {
    name = var.project-namespace
  }
}

# Install gitlab runner 
resource "helm_release" "gitlab-runner" {
  count            = var.runner-enabled ? 1 : 0
  name             = "gitlab-runner-${var.project-prefix}"
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab-runner"
  namespace        = "gitlab"
  create_namespace = true

  values = [<<EOF
    gitlabUrl: "https://gitlab.com/"
    runnerRegistrationToken: "${var.runner-token}"
    rbac:
      create: true
    runners:
      tags: "${var.runner-tag}"
      outputLimit: 131072
    concurrent: 100
  EOF
  ]
}

resource "kubernetes_cluster_role" "gitlab-runner" {
  count = var.runner-enabled ? 1 : 0
  metadata {
    name = "gitlab-runner-${var.project-prefix}-gitlab-runner"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
  depends_on = [helm_release.gitlab-runner]
}

resource "kubernetes_cluster_role_binding" "gitlab-runner" {
  count = var.runner-enabled ? 1 : 0
  metadata {
    name = "gitlab-runner-${var.project-prefix}-gitlab-runner"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "gitlab-runner-${var.project-prefix}-gitlab-runner"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "gitlab-runner-${var.project-prefix}-gitlab-runner"
    namespace = "gitlab"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "gitlab"
  }
  depends_on = [helm_release.gitlab-runner]
}


resource "helm_release" "alb-ingress-controller" {
  count      = var.alb-enabled ? 1 : 0
  name       = "alb-controller-${var.project-prefix}"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = var.alb-namespace

  values = [<<EOF
    serviceAccount:
      create: false
      name: ${var.alb-service-account-name}
    enableCertManager: false
    clusterName: ${var.cluster-name}
    region: ${var.aws-region}
    vpcId: ${var.vpc-id}
  EOF
  ]
}

# Install external dns
resource "helm_release" "external-dns-controller" {
  count      = var.dns-enabled ? 1 : 0
  name       = "external-dns-${var.project-prefix}"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = var.dns-namespace

  values = [<<EOF
    useDaemonset: false
    serviceAccount:
      create: false
      name: ${var.dns-service-account-name}

    rbac:
      create: true
      clusterRole: true

    podSecurityContext:
      enabled: true
      fsGroup: 1001
      runAsUser: 1001

    domainFilters: [""] 
    policy: sync
    registry: "txt"
    txtOwnerId: ${data.aws_route53_zone.hosted-zone.0.zone_id} 

    aws:
      region: ${var.aws-region}
      zoneType: ""

    crd:
      create: true

  EOF
  ]
}


################ Connect to postgres #################
resource "kubernetes_service" "database-service" {
  count = var.db.enabled ? 1 : 0
  metadata {
    name      = "core-db-${var.Environment}"
    namespace = var.project-namespace
  }
  spec {
    external_name = split(":", var.db.host)[0]
    type          = "ExternalName"
  }
}

resource "kubernetes_secret" "database-credentials" {
  count = var.db.enabled ? 1 : 0
  metadata {
    name      = var.db.secret-name
    namespace = var.project-namespace
  }

  data = {
    postgres-username = var.db.username
    postgres-password = var.db.password
    postgres-dbHost   = split(":", var.db.host)[0]
    postgres-dbName   = var.db.db-name
    postgres-port     = 5432
  }
}

data "tls_certificate" "tls-cert" {
  url = var.cluster-oidc-issuer
}


resource "aws_iam_openid_connect_provider" "oidc" {
  count = var.enabled ? 1 : 0
  url   = var.cluster-oidc-issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [data.tls_certificate.tls-cert.certificates[0].sha1_fingerprint]
}

######################
# aws-auth configmap
######################

locals {
  aws_auth_configmap_data = {
    mapRoles = yamlencode(
      [{
        rolearn  = var.node-role-arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes",
        ]
        }
      ],
    )
    mapUsers = yamlencode(concat(
      [for user in var.aws-auth-users : {
        userarn  = "${user}"
        username = user
        groups = [
          "system:masters",
        ]
        }
      ]
    ))
  }
}

resource "kubernetes_config_map" "aws_auth" {
  count = var.create_aws_auth_configmap ? 1 : 0

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = local.aws_auth_configmap_data

  # lifecycle {
  #   ignore_changes = [data, metadata[0].labels, metadata[0].annotations]
  # }
}

# resource "kubernetes_config_map_v1_data" "aws_auth" {
#   count = var.manage_aws_auth_configmap ? 1 : 0

#   force = true

#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = local.aws_auth_configmap_data

#   depends_on = [
#     kubernetes_config_map.aws_auth,
#   ]
# }



