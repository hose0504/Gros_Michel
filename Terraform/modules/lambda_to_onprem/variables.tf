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
  description = "S3 bucket for lambda deployment package"
  type        = string
}

variable "s3_key" {
  description = "S3 object key for lambda zip"
  type        = string
}



