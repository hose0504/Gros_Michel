module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id        # VPC 모듈의 출력 사용
  subnet_ids      = module.vpc.private_subnets # VPC 모듈의 출력 사용

  eks_managed_node_groups = {
    default = {
      instance_types         = ["t3.small"]
      min_size               = 3
      max_size               = 3
      desired_size           = 3
      vpc_security_group_ids = [module.eks_node_sg.security_group_id]
    }
  }

  # EKS API 서버 엔드포인트 접근 설정 (퍼블릭 접근 제한 강화)
  cluster_endpoint_public_access       = true
  # ✅ 보안 강화를 위해 특정 IP 대역만 허용 (매우 중요!)
  # 이곳에 var.my_public_ip를 사용하여 여러분의 PC IP 주소만 허용합니다.
  cluster_endpoint_public_access_cidrs = [var.my_public_ip] 
  cluster_endpoint_private_access      = true

  cluster_additional_security_group_ids = [module.eks_cluster_sg.security_group_id]
  enable_cluster_creator_admin_permissions = true
}

################################################################################
# Security Groups for EKS (EKS용 보안 그룹)
################################################################################

# EKS 클러스터 SG
module "eks_cluster_sg" {
  source = "terraform-aws-modules/security-group/aws"
  name   = "eks-cluster-sg"
  vpc_id = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                  = 443
      to_port                    = 443
      protocol                   = "tcp"
      # EC2 인스턴스 (Bastion 역할)에서 EKS API 서버 접근 허용
      source_security_group_id   = aws_security_group.ec2_sg.id # EC2 통합 SG 참조
    }
  ]

  ingress_with_self = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
    }
  ]

  egress_rules = ["all-all"]
}

# EKS 노드 SG
module "eks_node_sg" {
  source = "terraform-aws-modules/security-group/aws"
  name   = "eks-node-sg"
  vpc_id = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                  = 0
      to_port                    = 0
      protocol                   = "-1"
      source_security_group_id   = module.eks_cluster_sg.security_group_id
    }
  ]

  ingress_with_self = [
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
    }
  ]

  egress_rules = ["all-all"]
}

################################################################################
# IRSA for AWS Load Balancer Controller (IRSA for ALB 컨트롤러)
################################################################################

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
