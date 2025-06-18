output "cluster_name" {
  value = module.eks.cluster_name
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

# output "node_instance_ids" {
#   value = aws_autoscaling_group.eks_group.instances[*].instance_id
# }
