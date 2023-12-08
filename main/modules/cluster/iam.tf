#####################################
#  IAM Roles for Cluster and nodes  #
#####################################

# CLUSTER
resource "aws_iam_role" "cluster-role" {
  name = "${var.cluster.cluster-name}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


# With this POlicy EKS make calls to other AWS services on your behalf (autoscaling, ec2, elasticloadbalancing, iam, kms)
resource "aws_iam_role_policy_attachment" "amazon-EKS-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-role.name
}

resource "aws_iam_role_policy_attachment" "amazon-EKS-service-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster-role.name
}

resource "aws_iam_role_policy_attachment" "Amazon-EKS-VPC-ResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster-role.name
}


# NODES
resource "aws_iam_role" "node-role" {
  name = "${var.cluster.cluster-name}-eks-node-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon-EKS-worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-role.name
}

resource "aws_iam_role_policy_attachment" "amazon-EKS-CNI-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-role.name
}

/* 
 This policy grants read-only permissions to Amazon ECR. This includes the ability 
 to list repositories and images within the repositories. 
 It also includes the ability to pull images from Amazon ECR with the Docker CLI.
 */
resource "aws_iam_role_policy_attachment" "amazon-EC2-container-registry-ReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-role.name
}


resource "aws_iam_role_policy_attachment" "amazon-filesystem-access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
  role       = aws_iam_role.node-role.name
}
# Use an instance profile to pass an IAM role to an EC2 instance
resource "aws_iam_instance_profile" "node-profile" {
  name = "${var.cluster.cluster-name}-eks-node-instance-profile"
  role = aws_iam_role.node-role.name
}


