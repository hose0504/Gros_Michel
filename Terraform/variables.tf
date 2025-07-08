variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "region" {
  description = "AWS 리전"
  type        = string
}

variable "vpc_name" {
  description = "VPC 이름"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnets" {
  description = "퍼블릭 서브넷 목록"
  type        = list(string)
}

variable "private_subnets" {
  description = "프라이빗 서브넷 목록"
  type        = list(string)
}

variable "azs" {
  description = "가용 영역"
  type        = list(string)
}

variable "domain_name" {
  description = "도메인 이름"
  type        = string
}

variable "origin_domain_name" {
  description = "오리진 도메인"
  type        = string
}

variable "bucket_name" {
  description = "버킷 이름"
  type        = string
}

variable "project_id" {
  description = "프로젝트 ID"
  type        = string
}

variable "onprem_api_url" {
  description = "온프렘 API URL"
  type        = string
}

# Lambda 별 zip 경로 및 키
variable "lambda_zip_path_export" {
  description = "CloudWatch → S3 Lambda zip 경로"
  type        = string
}

variable "s3_key_export" {
  description = "CloudWatch → S3 Lambda S3 key"
  type        = string
}

variable "lambda_zip_path_forward" {
  description = "S3 → OnPrem Lambda zip 경로"
  type        = string
}

variable "s3_key_forward" {
  description = "S3 → OnPrem Lambda S3 key"
  type        = string
}

variable "s3_code_bucket_name" {
  description = "코드 저장용 S3 버킷"
  type        = string
}

variable "s3_bucket" {
  description = "로그 저장용 S3 버킷"
  type        = string
}
