# AWS 인증
variable "aws_access_key" {
  description = "AWS 액세스 키 ID (GitHub Secrets에서 가져옴)"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS 시크릿 액세스 키 (GitHub Secrets에서 가져옴)"
  type        = string
}

# 리전
variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "region" {
  description = "AWS 리전"
  type        = string
}

# 공통 인프라
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

# 추가로 필요한 변수들 (에러 해결용)
variable "environment" {
  description = "환경 이름 (예: dev, prod)"
  type        = string
}

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "cluster_version" {
  description = "EKS 클러스터 버전"
  type        = string
}

# Lambda 경로 및 S3 키 (main.tf와 이름 매칭)
variable "log_export_lambda_zip_path" {
  description = "CloudWatch → S3 Lambda zip 경로"
  type        = string
}

variable "log_export_s3_key" {
  description = "CloudWatch → S3 Lambda S3 key"
  type        = string
}

variable "onprem_lambda_zip_path" {
  description = "S3 → 온프렘 Lambda zip 경로"
  type        = string
}

variable "onprem_s3_key" {
  description = "S3 → 온프렘 Lambda S3 key"
  type        = string
}

# S3 버킷 관련
variable "s3_code_bucket_name" {
  description = "코드 저장용 S3 버킷"
  type        = string
}

variable "s3_bucket" {
  description = "로그 저장용 S3 버킷"
  type        = string
}

# 온프렘 API
variable "onprem_api_url" {
  description = "온프렘 API URL"
  type        = string
}

variable "private_key_raw" {
  description = "The raw content of the private key"
  type        = string
  sensitive   = true
}