module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  eks_managed_node_groups = {
    initial = {
      instance_types = ["t3.small"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }

  enable_cluster_creator_admin_permissions = true
}
