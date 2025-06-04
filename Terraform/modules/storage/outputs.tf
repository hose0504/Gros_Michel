output "bucket_name" {
  value = aws_s3_bucket.db_cache.id
}

output "bucket_domain" {
  value = aws_s3_bucket.db_cache.bucket_regional_domain_name
}

output "bucket_zone_id" {
  value = aws_s3_bucket.db_cache.hosted_zone_id
}
