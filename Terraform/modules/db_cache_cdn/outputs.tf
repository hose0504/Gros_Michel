output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

variable "bucket_name" {
  description = "Shared S3 bucket name used by CloudFront"
  type        = string
}
