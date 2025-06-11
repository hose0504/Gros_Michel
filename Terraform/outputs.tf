output "vpc_id" {
  value = module.network.vpc_id
}

output "bucket_name" {
  value = module.storage.bucket_name
}

output "cloudfront_url" {
  value = module.cdn.cdn_domain_name
}

output "route53_zone_id" {
  value = module.dns.zone_id
}

output "web_ec2_instance_id" {
  value = module.web_ec2.instance_id
}

output "web_ec2_public_ip" {
  value = module.web_ec2.public_ip
}
