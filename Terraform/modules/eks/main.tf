provider "aws" {
  region = var.region
}

resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg"
  description = "Allow communication between EKS nodes and cluster"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow all traffic from EKS cluster SG"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [module.eks.cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-node-sg"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.public_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  enable_irsa                     = true

  eks_managed_node_groups = {
    default = {
      desired_size           = 1
      max_size               = 3
      min_size               = 1
      instance_types         = ["t3.small"]
      vpc_security_group_ids = [aws_security_group.eks_node_sg.id] # 👈 SG 직접 지정!
    }
  }

  enable_cluster_creator_admin_permissions = true
}

data "aws_eks_cluster" "main" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "main" {
  name = module.eks.cluster_name
}

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
