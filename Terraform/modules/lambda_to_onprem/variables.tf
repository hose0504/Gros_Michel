variable "region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "ap-northeast-2"
}

variable "s3_bucket" {
  description = "S3 bucket where Lambda zip is stored"
  type        = string
  default     = "aws-monitor-code-bucket"
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
