output "bucket_domain_name" {
  value = aws_s3_bucket.shared.bucket_regional_domain_name
}

output "bucket_zone_id" {
  value = aws_s3_bucket.db_cache.hosted_zone_id
}

output "bucket_arn" {
  value = aws_s3_bucket.shared.arn
}