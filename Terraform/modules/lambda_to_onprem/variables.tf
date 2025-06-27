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
  description = "S3 bucket that contains the Lambda function payload"
  type        = string
}

variable "s3_key" {
  description = "S3 key (path) to the Lambda function .zip file"
  type        = string
}

variable "onprem_api_url" {
  description = "The HTTP endpoint for the on-premises log receiver"
  type        = string
}

variable "onprem_api_url" {
  description = "The endpoint for the on-premise log receiver"
  type        = string
}




