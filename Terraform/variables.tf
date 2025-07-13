# AWS 기본 정보
variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

# VPC 네트워크 관련
variable "vpc_name" {
  description = "VPC 이름"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  type        = string
}

variable "public_subnets" {
  description = "퍼블릭 서브넷 CIDR 목록"
  type        = list(string)
}

variable "private_subnets" {
  description = "프라이빗 서브넷 CIDR 목록"
  type        = list(string)
}

variable "azs" {
  description = "사용할 가용 영역 리스트"
  type        = list(string)
}

variable "domain_name" {
  description = "Route53에서 사용할 도메인 이름 (예: grosmichel.click)"
  type        = string
  default     = ""
}

# NAT 인스턴스용
variable "key_name" {
  description = "EC2 Key Pair 이름 (NAT, Bastion 등에 사용)"
  type        = string
}

variable "nat_ami_id" {
  description = "NAT 인스턴스에 사용할 AMI ID"
  type        = string
}

# EKS 관련
variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
  default     = "gros-cluster"
}

variable "cluster_version" {
  description = "EKS 클러스터 버전"
  type        = string
  default     = "1.29"
}

# EC2 접속용 SSH
variable "private_key_path" {
  description = "SSH 접속용 개인 키 경로"
  type        = string
  default     = ""
}

variable "private_key_raw" {
  description = "SSH 접속용 개인 키 내용"
  type        = string
  default     = ""
}

# 환경 설정 (prod/dev 등)
variable "environment" {
  description = "배포 환경 이름"
  type        = string
  default     = "prod"
}

# 로깅 및 Lambda 관련
variable "s3_bucket" {
  description = "Lambda Zip 파일이 저장된 S3 버킷"
  type        = string
}

variable "s3_code_bucket_name" {
  description = "Lambda 배포용 코드 버킷 이름"
  type        = string
  default     = "aws-monitor-code-bucket"
}

variable "log_export_lambda_zip_path" {
  description = "CloudWatch → S3 Lambda zip 로컬 경로"
  type        = string
}

variable "log_export_s3_key" {
  description = "CloudWatch → S3 Lambda zip S3 key"
  type        = string
}

variable "onprem_lambda_zip_path" {
  description = "S3 → 온프렘 Lambda zip 로컬 경로"
  type        = string
}

variable "onprem_s3_key" {
  description = "S3 → 온프렘 Lambda zip S3 key"
  type        = string
}

variable "onprem_api_url" {
  description = "온프렘 로그 수신기 URL"
  type        = string
  default     = "http://172.30.192.49:8080/logs"
}

# GCP용으로 사용 예정이지만 지금은 안 쓰는 변수 (형식 맞추기용)
variable "project_id" {
  description = "Project 식별자 (GCP용 placeholder)"
  type        = string
}

variable "origin_domain_name" {
  description = "S3 오리진 도메인 이름 (예: team5-db-cache.s3.ap-northeast-2.amazonaws.com)"
  type        = string
}

variable "region" {
  description = "Region for AWS resources"
  type        = string
}

variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "nat_instance_eni" {
  description = "ENI ID of the pre-created NAT instance"
  type        = string
}

