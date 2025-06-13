variable "domain_name" {
  description = "Route53에서 사용할 도메인 이름 (예: grosmichel.click)"
  type        = string
}

variable "regions" {
  description = "리전별 CloudFront alias 레코드를 위한 정보 목록"
  type = list(object({
    name        = string # 식별자 (예: seoul, virginia)
    aws_region  = string # AWS 리전 코드 (예: ap-northeast-2)
    cdn_domain  = string # CloudFront 도메인 이름 (예: abc.cloudfront.net)
    cdn_zone_id = string # CloudFront hosted zone ID
  }))
}

variable "alb_dns_name" {
  description = "Application Load Balancer DNS 이름"
  type        = string
}

variable "alb_zone_id" {
  description = "Application Load Balancer Zone ID"
  type        = string
}
