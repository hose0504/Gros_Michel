module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      instance_types         = ["t3.small"]
      min_size               = 1
      max_size               = 3
      desired_size           = 1
      vpc_security_group_ids = [module.eks_node_sg.security_group_id]
    }
  }

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_additional_security_group_ids = [module.eks_cluster_sg.security_group_id]
  enable_cluster_creator_admin_permissions = true
}

module "eks_cluster_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  name    = "eks-cluster-sg"
  vpc_id  = module.vpc.vpc_id

  ingress_with_self = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
    }
  ]

  egress_rules = ["all-all"]
}

module "eks_node_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  name    = "eks-node-sg"
  vpc_id  = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      source_security_group_id = module.eks_cluster_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]
}

# IRSA 설정
data "aws_iam_openid_connect_provider" "oidc" {
  url = module.eks.cluster_oidc_issuer_url
}

resource "aws_iam_role" "alb_controller_irsa" {
  name = "alb-controller-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = module.eks.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(module.eks.oidc_provider, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_controller_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy"
}
