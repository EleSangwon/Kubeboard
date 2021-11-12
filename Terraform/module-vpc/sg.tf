module "security_groups" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "bolt-eks-sg"
  description = "Security group for EKS Cluster within VPC"
  vpc_id      = module.vpc.vpc_id
  security_group_id = "bolt-sg-id"    
  ingress_cidr_blocks = ["10.10.0.0/16"]
}