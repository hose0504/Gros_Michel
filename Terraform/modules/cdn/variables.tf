variable "origin_domain_name" {
  description = "S3 버킷 도메인 이름 (예: bucket-name.s3.ap-northeast-2.amazonaws.com)"
  type        = string
}

variable "tag_name" {
  description = "CloudFront 배포 리소스 이름 태그"
  type        = string
  default     = "GlobalWebCDN"
}

variable "environment" {
  description = "운영 환경 (예: dev, prod)"
  type        = string
  default     = "prod"
}
