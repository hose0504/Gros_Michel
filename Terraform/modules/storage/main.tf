resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "shared" {
  bucket        = "team5-shared-storage-${random_id.bucket.hex}"
  force_destroy = true

  tags = {
    Name        = "SharedStorage"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.shared.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
