resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "db_cache" {
  bucket        = "team5-db-cache-${random_id.bucket.hex}"
  force_destroy = true

  tags = {
    Name        = "DBCacheStorage"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_public_access_block" "db_cache_block" {
  bucket = aws_s3_bucket.db_cache.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
