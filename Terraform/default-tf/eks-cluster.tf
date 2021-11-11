data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  vpc_id = module.vpc.name
  cluster_version = "1.21"
  cluster_name    = "bolt-cluster"
  subnets         = [ for zone in module.vpc.private_subnets: zone ]

  worker_groups = [
    {
      instance_type = "t2.medium"
      asg_max_size  = 5
      asg_min_size  = 5
      asg_desired_size  = 5
      
    }
  ]
}