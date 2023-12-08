variable "cluster-name" {
  type        = string
  description = "EKS Cluster name"
}

variable "project-prefix" {
  description = "Project prefix"
  type        = string
}

variable "Environment" {
  description = "Environemnt name."
  type        = string
}

variable "vpc-id" {
  type        = string
  description = "VPC ID "
}

variable "image-ami" {
  type        = string
  description = "Image AMI  to be used for the autoscaling group for the bastion host "
}

variable "ec2-public-key" {
  type        = string
  description = "SSH Public key "
}

variable "aws-region" {
  type        = string
  description = "AWS Region "
}



variable "enabled" {
  type        = bool
  description = "Enable/disable the module "
}

variable "name" {
  type        = string
  description = "Bastion host name "
}

variable "ingress-cidr-blocks" {
  type        = list(string)
  description = "Security groups inbound rules "
}


variable "instance-type" {
  type        = string
  description = "Ec2 instance type "
}

variable "volume-size" {
  type        = string
  description = "Volume size "
}

variable "volume-type" {
  type        = string
  description = "Volume type "
}

variable "min-size" {
  type        = string
  description = "Autoscaling group Min size "
}

variable "max-size" {
  type        = string
  description = "Autoscaling group max size "
}

variable "desired-size" {
  type        = string
  description = "Min size "
}

