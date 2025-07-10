module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.public_subnets

  cluster_endpoint_public_access             = true
  enable_cluster_creator_admin_permissions   = true

  eks_managed_node_groups = {
    default = {
      desired_size   = 1
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.small"]
    }
  }
}