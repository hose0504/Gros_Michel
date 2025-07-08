output "bucket_zone_id" {
  value = aws_s3_bucket.shared
}

output "bucket_arn" {
  value = aws_s3_bucket.shared.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.shared.bucket_regional_domain_name
}

output "bucket_name" {
  value = aws_s3_bucket.shared.bucket
}

output "bucket_domain" {
  value = aws_s3_bucket.shared.bucket_regional_domain_name
}
