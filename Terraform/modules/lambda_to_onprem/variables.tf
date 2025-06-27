variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
  default     = "/aws/lambda/app-error"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "lambda-to-onprem-logger"
}

variable "s3_bucket" {
  description = "Lambda 코드가 저장된 S3 버킷"
  type        = string
}

variable "s3_key" {
  description = "Lambda 코드 ZIP 파일 경로 (S3 내)"
  type        = string
}




