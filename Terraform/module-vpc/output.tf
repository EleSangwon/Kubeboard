output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.public_subnets
}

output "vpc_id"{
    description="ID of VPC"
    value = module.vpc.vpc_id
}

output "azs" {
    description="List of azs"
    value = module.vpc.azs
}

output "security_group_name" {
    description="Name of Security Group"
    value = module.security_groups.security_group_name
}

output "security_group_id" {
    description="Name of Security Group"
    value = module.security_groups.security_group_id
}
output "security_group_vpc_id" {
    description="Name of Security Group"
    value = module.security_groups.security_group_vpc_id
}

output "kubectl_config" {
    value = module.eks.kubeconfig
}

output "config_map_aws_auth" {
    value = module.eks.config_map_aws_auth
}
output "cluster_security_group_id"{
    value = module.eks.cluster_security_group_id
}
output "node_groups"{
    value = module.eks.node_groups
}