#################
#  EKS Cluster  # 
#################



resource "aws_eks_cluster" "eks-cluster" {
  name = var.cluster.cluster-name

  version = var.cluster.k8s-version

  role_arn = aws_iam_role.cluster-role.arn

  vpc_config {
    security_group_ids = var.bastion-enabled ? [data.aws_security_group.cluster.id, data.aws_security_group.cluster-ssh-vpc.0.id] : [data.aws_security_group.cluster.id]
    subnet_ids         = data.aws_subnets.private.ids
    endpoint_private_access = true 
    endpoint_public_access = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
  depends_on = [
    aws_iam_role_policy_attachment.amazon-EKS-cluster-policy,
    aws_iam_role_policy_attachment.amazon-EKS-service-policy,
    aws_iam_role_policy_attachment.Amazon-EKS-VPC-ResourceController
  ]

  tags = {
    Environment = var.Environment
    CreatedBy   = "Terraform"
    Name        = var.cluster.cluster-name
  }
}

############################
#  EKS Managed Node group  # 
############################

resource "aws_eks_node_group" "eks-node-group" {
  count = length(var.cluster.nodes)

  cluster_name    = var.cluster.cluster-name
  node_group_name = "${var.cluster.cluster-name}-node-group-${count.index}"
  node_role_arn   = aws_iam_role.node-role.arn
  subnet_ids      = data.aws_subnets.private.ids
  disk_size = 200
  
  labels = var.cluster.nodes[count.index].labels
  
  dynamic "taint" {
    for_each = var.cluster.nodes[count.index].taints

    content {
      key    = var.cluster.nodes[count.index].taints.key
      value  = try(var.cluster.nodes[count.index].taints.value, null)
      effect = var.cluster.nodes[count.index].taints.effect
    }
  }

  ami_type       = var.cluster.nodes[count.index].ami_type

  scaling_config {
    desired_size = var.cluster.nodes[count.index].node-count
    max_size     = var.cluster.nodes[count.index].max
    min_size     = var.cluster.nodes[count.index].min
  }

  instance_types = [
    var.cluster.nodes[count.index].instance-type
  ]

  depends_on = [
    aws_eks_cluster.eks-cluster,
    aws_iam_role_policy_attachment.amazon-EKS-worker-node-policy,
    aws_iam_role_policy_attachment.amazon-EKS-CNI-policy,
    aws_iam_role_policy_attachment.amazon-EC2-container-registry-ReadOnly
  ]

  timeouts {
    create = "180m"
  }

  tags = {
    Name        = "${var.cluster.cluster-name}-node-group-${count.index}"
    Environment = var.Environment
    CreatedBy   = "Terraform"
  }


}