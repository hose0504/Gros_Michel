variable "region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "ap-northeast-2"
}

variable "s3_bucket" {
  description = "S3 bucket where Lambda zip is stored"
  type        = string
  default     = "aws-monitor-error"  # ← 수정됨
}

variable "s3_key" {
  description = "Lambda deployment package zip file key"
  type        = string
  default     = "lambda_function_payload.zip"
}

variable "onprem_api_url" {
  description = "URL of the on-premises server to POST logs to"
  type        = string
  default     = "http://your-onprem-server/log"
}

variable "s3_code_bucket_name" {
  description = "S3 bucket name for Lambda code"
  type        = string
  default     = "aws-monitor-code-bucket"
}


variable "lambda_zip_path" {
  description = "Local path to the Lambda function zip file"
  type        = string
}
