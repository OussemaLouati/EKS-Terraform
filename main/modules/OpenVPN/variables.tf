variable "azs" {
  type        = list(string)
  description = "The AWS AZ to deploy Openvpn"
}

variable "vpc" {
  type        = string
  description = "VPC CIDR block"
}

variable "private-subnets" {
  type        = list(string)
  description = "Openvpn private subnets"
}

variable "public-subnets" {
  type        = list(string)
  description = "Openvpn private subnets"
}

variable "aws-region" {
  type        = string
  description = "AWS Region "
}

variable "cluster-name" {
  type        = string
  description = "EKS Cluster name"
}

variable "project-prefix" {
  description = "Project prefix"
  type        = string
}

variable "Environment" {
  description = "Environemtn name."
  type        = string
}

variable "acceptor-vpc-id" {
  type        = string
  description = "VPC ID to use in the vpc peering with the openvpn vpc "
}

variable "ec2-public-key" {
  type        = string
  description = "SSH Public key "
}

