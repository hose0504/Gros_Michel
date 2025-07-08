output "route53_zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "root_record" {
  value = aws_route53_record.root.fqdn
}

output "www_record" {
  value = aws_route53_record.www.fqdn
}
