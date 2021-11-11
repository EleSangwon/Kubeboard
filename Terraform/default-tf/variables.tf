variable "region" {
  default     = "ap-northeast-2"
  description = "AWS region"
}
variable "cluster_name" {
  default = "terraform-eks-bolt"
  type    = string
}
