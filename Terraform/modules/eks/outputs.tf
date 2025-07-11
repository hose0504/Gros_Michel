output "eks_cluster_name" {
  value = module.eks.cluster_name
}

# OIDC URL (정확한 이름 사용)
output "oidc_provider" {
  value = module.eks.oidc_provider
}

# OIDC ARN
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

# IRSA로 생성된 ALB Role (존재할 경우에만 사용)
# aws_iam_role.alb_irsa 리소스가 존재할 때만 유지하세요.
output "alb_irsa_role_arn" {
  value = aws_iam_role.alb_irsa.arn
}

