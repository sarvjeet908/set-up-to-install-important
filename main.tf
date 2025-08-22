provider "aws" {
  region = var.aws_region
}

locals {
  today = formatdate("2006-01-02", timestamp())
  common_tags = {
    BU                                  = "Cloud Infrastructure"
    Client                              = "company-name"
    Company                             = "company-name"
    CreationDate                        = local.today
    DeleteOn                            = local.today
    Dept                                = "CIS"
    Environment                         = "Dev"
    Owner                               = "emailid"
    Project                             = "EKS-Migration"
    Schedule                            = "working hours"
    "alpha.eksctl.io/cluster-oidc-enabled" = "true"
  }
}

data "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name
}

data "aws_iam_role" "eks_node_role" {
  name = var.eks_node_role_name
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.eks_cluster_role.arn
  version  = "1.33"

  vpc_config {
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = var.cluster_security_group_ids
  }

  kubernetes_network_config {
    ip_family = var.cluster_ip_family
  }

  tags = local.common_tags
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = data.aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [var.node_instance_type]
  disk_size       = 20
  ami_type        = "AL2023_x86_64_STANDARD"
  version         = "1.33"

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = var.node_security_group_ids
  }

  scaling_config {
    desired_size = var.desired_capacity
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = local.common_tags
}

# ---------------------
# Variables declaration
# ---------------------

variable "aws_region" {}
variable "vpc_id" {}

variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_security_group_ids" {
  type = list(string)
}
variable "node_security_group_ids" {
  type = list(string)
}

variable "eks_cluster_role_name" {}
variable "eks_node_role_name" {}

variable "cluster_name" {}
variable "node_group_name" {}
variable "node_instance_type" {}

variable "desired_capacity" {
  type = number
}
variable "min_size" {
  type = number
}
variable "max_size" {
  type = number
}

variable "ssh_key_name" {}
variable "cluster_ip_family" {
  default = "ipv4"
}

