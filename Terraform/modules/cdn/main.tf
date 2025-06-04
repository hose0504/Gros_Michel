resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = var.origin_domain_name # 예: bucket-name.s3.ap-northeast-2.amazonaws.com
    origin_id   = "cdn-origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "cdn-origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100" # 아시아 및 북미 리전만 사용, 비용 최적화 목적 (확장 가능)

  viewer_certificate {
    cloudfront_default_certificate = true
    # 추후 ACM 인증서 사용 시 아래 옵션을 활성화:
    # acm_certificate_arn = var.acm_cert_arn
    # ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = var.tag_name
    Environment = var.environment
  }
}
