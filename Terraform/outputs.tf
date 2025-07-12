output "vpc_id" {
  value = module.network.vpc_id
}
output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}
output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}
output "private_route_table_id" {
  value = module.network.private_route_table_id
}
output "bucket_name" {
  value = module.storage.bucket_name
}
output "cloudfront_url" {
  value = module.cdn.cdn_domain_name
}
output "web_ec2_instance_id" {
  value = module.web_ec2.instance_id
}
output "web_ec2_public_ip" {
  value = module.web_ec2.public_ip
}
output "alb_dns_name" {
  value = aws_lb.this.dns_name
}
output "web_tg_arn" {
  value = aws_lb_target_group.web_tg.arn
}
