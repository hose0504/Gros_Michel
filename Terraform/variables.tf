variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "vpc_name" {}
variable "vpc_cidr_block" {}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "domain_name" {
  description = "Route53에서 사용할 도메인 이름 (예: grosmichel.click)"
  type        = string
}

variable "cluster_name" {
  description = "gros_michel_EKS"
  type        = string
  default     = "gros-cluster"
}

variable "cluster_version" {
  description = "1.32"
  type        = string
  default     = "1.29"
}

variable "origin_domain_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "region" {
  description = "Region for AWS resources"
  type        = string
}

variable "project_id" {
  description = "Project identifier (사용 안 해도 명세 맞춰서)"
  type        = string
}

variable "onprem_api_url" {
  description = "URL for on-prem log receiver"
  type        = string
  default     = "http://112.221.198.140:10005/logs"
}

variable "s3_bucket" {
  description = "S3 bucket containing the Lambda zip"
  type        = string
}

variable "s3_key" {
  description = "S3 key of the Lambda zip"
  type        = string
}

variable "s3_code_bucket_name" {
  description = "S3 bucket for Lambda deployment code"
  type        = string
  default     = "aws-monitor-code-bucket"
}

variable "lambda_zip_path" {
  type        = string
  description = "Lambda zip 파일 경로 (로컬 경로)"
}
