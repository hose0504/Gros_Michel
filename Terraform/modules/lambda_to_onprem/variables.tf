variable "lambda_zip_path" {
  description = "Local path to the lambda zip file for source_code_hash"
  type        = string
}

variable "s3_code_bucket_name" {
  description = "S3 bucket that stores Lambda code"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket where Lambda code is stored"
  type        = string
}

variable "s3_key" {
  description = "S3 key of the Lambda zip file"
  type        = string
}

variable "onprem_api_url" {
  description = "URL of on-prem API for log forwarding"
  type        = string
}
