resource "aws_route53_zone" "main" {
  name = "grosmichel.click"
}

resource "aws_route53_record" "www_seoul" {
  zone_id        = aws_route53_zone.main.zone_id
  name           = "www.grosmichel.click"
  type           = "A"
  set_identifier = "seoul"
  region         = "ap-northeast-2"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = "ap-northeast-2"
  }
}

resource "aws_route53_record" "www_virginia" {
  zone_id        = aws_route53_zone.main.zone_id
  name           = "www.grosmichel.click"
  type           = "A"
  set_identifier = "virginia"
  region         = "us-east-1"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = "us-east-1"
  }
}
