variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

output "bucket_domain_name" {
  value = aws_s3_bucket.shared.bucket_regional_domain_name
}