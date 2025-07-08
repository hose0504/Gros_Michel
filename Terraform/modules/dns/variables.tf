variable "domain_name" {
  description = "The root domain name (e.g., grosmichel.click)"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB to point to"
  type        = string
}

variable "alb_zone_id" {
  description = "The zone ID of the ALB"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront 배포의 도메인 이름"
  type        = string
  default     = null
}
