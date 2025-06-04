# 이 모듈은 외부에서 전달받을 변수가 없음.
# 필요 시 bucket_prefix 등으로 추후 확장 가능.
output "bucket_name" {
  value = aws_s3_bucket.db_cache.id
}

output "bucket_domain" {
  value = aws_s3_bucket.db_cache.bucket_regional_domain_name
}

output "bucket_zone_id" {
  value = aws_s3_bucket.db_cache.hosted_zone_id
}
