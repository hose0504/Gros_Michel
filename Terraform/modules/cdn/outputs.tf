output "domain_name" {
  description = "CloudFront 배포 도메인 이름"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "hosted_zone_id" {
  description = "CloudFront의 Route 53 호스팅 존 ID"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}
