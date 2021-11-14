variable "region" {
  default     = "ap-northeast-2"
  description = "AWS region"
}
provider "aws" {
  region = var.region
}
data "aws_availability_zones" "available" {}

locals {
  cluster_name = "bolt-eks"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = "bolt-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
module "security_groups" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "bolt-eks-sg"
  description = "Security group for EKS Cluster within VPC"
  vpc_id      = module.vpc.vpc_id
  security_group_id = "bolt-sg-id"    
  ingress_cidr_blocks = ["10.10.0.0/16"]
}