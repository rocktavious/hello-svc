terraform {
  required_version = ">= 0.12"
}

provider "local" {
  version = "~> 1.2"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = "us-east-1"
}

provider "kubernetes" {
  load_config_file       = "false"
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

data "aws_availability_zones" "available" {}

locals {
  region          = "us-east-1"
  color           = "blue"
  cluster_name    = "eks-${local.color}"
  cidr            = "10.0.0.0/16"
  subnets         = cidrsubnets(local.cidr,3,3,3,3,3,3)
  private_subnets = [local.subnets[0], local.subnets[1], local.subnets[2]]
  public_subnets  = [local.subnets[3], local.subnets[4], local.subnets[5]]
}
